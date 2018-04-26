class AccessRequestsController < ApplicationController
  include AccessRequestsHelper

  before_action :authenticate_user!
  before_action :find_access_request, except: [:index, :new, :create, :preview, :possible_templates]

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

    @access_requests = current_user.access_requests.includes(:campaign, :comments, organization: [:sector, address: [:country]], workflow: [{workflow_state: [:workflow_state_form, :possible_transitions]}, {workflow_transitions: [:transition, :event] }]).where(campaign_id: @campaign.id).order('created_at DESC')
    @download_ar = nil
    if session['download_ar']
      @download_ar = session['download_ar']
      session['download_ar'] = nil
    end
  end

  def new
    @access_request = AccessRequest.new
    @access_request.existing = request.url.include?('existing')
    @organization = Organization.new
    @access_request.sent_date = Date.today
    @templates = []
    @selected_template = nil
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
    @templates = AccessRequest.available_templates(:access_request, organization)
    @selected_template ||= begin
      if @templates.blank?
        nil
      elsif mylang_version = @templates.detect {|t| t.language == current_user.preferred_language}
        mylang_version
      else
        @templates.first
      end
    end
    @rendered_template = AccessRequest.get_rendered_template(:access_request, current_user, @campaign, organization, nil, @selected_template)
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

    if @access_request.existing# user attached existing access request file
      @access_request.final_text = nil
      @access_request.suggested_text = nil
      if @access_request.access_request_file
        @access_request.access_request_file_content_type = @access_request.access_request_file&.content_type
        @access_request.access_request_file = @access_request.access_request_file.read
      end
    end

    if @access_request.save
      session['download_ar'] = @access_request.id unless @access_request.existing
      redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
    elsif @access_request.existing
      redirect_to campaign_access_requests_existing_path(campaign_id: @access_request.campaign_id), alert: @access_request.errors.full_messages.join(',')
    else
      render 'new', alert: @access_request.errors.full_messages.join(',')
    end
  end

  def edit
    @campaign = Campaign.find params[:campaign_id]
    @campaign_count = AccessRequest.where('campaign_id = ? AND user_id = ?', @campaign.id,current_user.id).count

    unless @access_request.existing
      @rendered_template = @access_request.final_text
      @templates = AccessRequest.available_templates(:access_request, @access_request.organization)
      @selected_template ||= begin
        if @templates.blank?
          nil
        elsif mylang_version = @templates.detect {|t| t.language == current_user.preferred_language}
          mylang_version
        else
          @templates.first
        end
      end
    end
  end

  def update
    @access_request.assign_attributes(access_request_params)
    if @access_request.existing && params[:access_request][:access_request_file]
      @access_request.access_request_file_content_type = @access_request.access_request_file&.content_type
      @access_request.access_request_file = @access_request.access_request_file.read
    end
    if @access_request.save
      session['download_ar'] = @access_request.id unless @access_request.existing
      redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
    else
      redirect_to edit_campaign_access_request_path(campaign_id: @access_request.campaign_id, id: @access_request.id), alert: @access_request.errors.full_messages.join(',')
    end
  end

  def preview
    @rendered_template = params[:rendered_template]
    @rendered_template ||= ''
    pdf = WickedPdf.new.pdf_from_string(@rendered_template, encoding: 'UTF-8')
    send_data(pdf, :type => :pdf, :disposition => 'inline')
  end

  def download
    if @access_request.final_text.blank?
      send_data(@access_request.access_request_file, :filename => "AccessRequest-#{@access_request.id}-#{@access_request.organization.name}", :type => @access_request.access_request_file_content_type)
    else
      pdf = WickedPdf.new.pdf_from_string(@access_request.final_text&.html_safe, encoding: 'UTF-8')
      send_data(pdf, :filename => "AccessRequest-#{@access_request.id}-#{@access_request.organization.name}" ,:type => :pdf)
    end
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

  def possible_templates
    organization = Organization.find params[:organization_id]
    render json: {success: true, templates: AccessRequest.available_templates(:access_request, organization).pluck(:id, :version)}
  end

  def template
    render json: { success: true, template: @access_request.get_rendered_template(params[:template_type].to_sym) }
  end

  private
   def access_request_params
     params.require(:access_request).permit(:organization_id, :campaign_id, :sent_date, :suggested_text, :final_text, :existing, :access_request_file, :sending_method_id, :sending_method_remarks)
   end

   def find_access_request
    @access_request = AccessRequest.find(params[:id])
    unless @access_request.user_id == current_user.id
      raise "Access Request does not belong to your user: #{@access_request.user_id} != #{current_user.id}"
    end
   end
end
