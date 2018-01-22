class AccessRequestsController < ApplicationController
  include AccessRequestsHelper

  before_action :authenticate_user!
  before_action :find_access_request, except: [:index, :new, :create, :preview]

  def index
    @access_requests = []
    @campaign = Campaign.find_by id: params[:campaign_id]
    pc = @campaign.policy_consent
    pc = PolicyConsent.find_by(type_of: :campaign) if pc.nil?
    if pc
      upc = UserPolicyConsent.find_or_create_by user_id: current_user.id, policy_consent_id: pc.id
      unless upc.approved
        redirect_to user_profile_for_campaign_path(@campaign) and return
      end
    end

    @access_requests = current_user.access_requests.includes(:campaign, :comments, organization: [:sector, address: [:city, :country]], workflow: [{workflow_state: [:workflow_state_form, :possible_transitions]}, {workflow_transitions: [:transition, :event] }]).where(campaign_id: @campaign.id).order('created_at DESC')
    @download_ar = nil
    if session['download_ar']
      @download_ar = session['download_ar']
      session['download_ar'] = nil
    end
  end

  def new
    @access_request = AccessRequest.new
    @access_request.sent_date = Date.today
    campaign_id = params[:campaign_id]
    campaign_id = Campaign.find_by(:name => Campaign::DEFAULT_CAMPAIGN_NAME) unless campaign_id
    unless campaign_id
      flash[:notice] = I18n.t('errors.campaign_not_found')
      redirect_to home_path and return
    end
    @campaign = Campaign.find campaign_id
    unless @campaign
      flash[:notice] = I18n.t('errors.campaign_not_found')
      redirect_to home_path and return
    end
    @access_request.campaign_id = @campaign.id
    @campaign_count = AccessRequest.where('campaign_id = ? AND user_id = ?', @campaign.id,current_user.id).count
    @sectors = get_sectors(@campaign)
    @selected_sector = @sectors.first
    @organizations = get_campaign_organizations(@campaign, Sector.find_by_id(@selected_sector[1]))  if @selected_sector
    @organizations ||= []
    @selected_organization = @organizations.first
    unless @selected_organization
      flash[:notice] = I18n.t('errors.organization_not_found')
      redirect_to home_path and return
    end
    organization = Organization.find_by_id(@selected_organization[1])
    @rendered_template = AccessRequest.get_rendered_template(:access_request, current_user, @campaign, organization)
    unless @rendered_template
      flash[:notice] = I18n.t('errors.template_version_not_found')
      redirect_to home_path and return
    end
    @access_request.suggested_text = @rendered_template&.html_safe
    @access_request.final_text = @rendered_template
  end

  def create
    @access_request = AccessRequest.new(access_request_params)
    @access_request.user = current_user
    unless params['textTypeRadios'] == 'expanded'
      @access_request.final_text = @access_request.suggested_text
    end
    if @access_request.save
      session['download_ar'] = @access_request.id
      redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
    else
      render 'new'
    end
  end

  def edit
    @campaign = Campaign.find params[:campaign_id]
    @campaign_count = AccessRequest.where('campaign_id = ? AND user_id = ?', @campaign.id,current_user.id).count
    @rendered_template = @access_request.final_text
  end

  def update
    if @access_request.update(access_request_params)
      session['download_ar'] = @access_request.id
      redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
    else
      render 'edit'
    end
  end

  def preview
    @rendered_template = params[:rendered_template]
    @rendered_template ||= ''
    pdf = WickedPdf.new.pdf_from_string(@rendered_template, encoding: 'UTF-8')
    send_data(pdf, :type => :pdf, :disposition => 'inline')
  end

  def download
    pdf = WickedPdf.new.pdf_from_string(@access_request.final_text&.html_safe, encoding: 'UTF-8')
    send_data(pdf, :filename => "AccessRequest-#{@access_request.id}-#{@access_request.organization.name}" ,:type => :pdf)
  end

  def comment
    c = Comment.new
    c.content = params[:content]
    c.user = current_user
    @access_request.comments << c
    if @access_request.save
      @result = 'success'
    else
      @result = @access_request.errors.full_messages.join(". ")
    end
  end

  private
   def access_request_params
     params.require(:access_request).permit(:organization_id, :campaign_id, :sent_date, :suggested_text, :final_text)
   end

   def find_access_request
    @access_request = AccessRequest.find(params[:id])
    unless @access_request.user_id == current_user.id
      head(500)
    end

  end
end
