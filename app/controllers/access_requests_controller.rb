class AccessRequestsController < ApplicationController
  include AccessRequestsHelper

  before_action :authenticate_user!

  def index
    @campaign = Campaign.find_by id: params[:campaign_id]
    @access_requests = current_user.access_requests.where(campaign_id: @campaign.id).order('created_at DESC')
    @download_ar = nil
    if session['download_ar']
      @download_ar = session['download_ar']
      session['download_ar'] = nil
    end
  end

  def new
    campaign_id = params[:campaign_id]
    campaign_id = Campaign.find_by(:name => Campaign::DEFAULT_CAMPAIGN_NAME) unless campaign_id
    unless campaign_id
      flash[:notice] = I18n.t('errors.campaign_not_found')
      redirect_to home_path and return
    end
    @campaign = Campaign.find_by_id  campaign_id
    unless @campaign
      flash[:notice] = I18n.t('errors.campaign_not_found')
      redirect_to home_path and return
    end
    @campaign_id = @campaign.id
    @campaign_name = @campaign.name
    @campaign_count = AccessRequest.where('campaign_id = ? AND user_id = ?', @campaign.id,current_user.id).count
    @campaign_desc = @campaign.expanded_description

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
  end

  def download
    ar = AccessRequest.find(params[:id])
    return unless ar.user_id == current_user.id
    pdf = WickedPdf.new.pdf_from_string(ar.final_text.html_safe, encoding: 'UTF-8')
    send_data(pdf, :filename => "AccessRequest-#{ar.id}-#{ar.organization.name}" ,:type => :pdf)
  end

  def create
    @access_request = AccessRequest.new
    @access_request.organization_id = params['organization_id']
    @access_request.user = current_user
    @access_request.sent_date = params['sending_date']
    @access_request.campaign_id = params['campaign_id']
    @access_request.suggested_text = params['standard_text']
    if params['textTypeRadios'] == 'expanded'
      @access_request.final_text = params['custom_text']
    else
      @access_request.final_text = params['standard_text']
    end
    @access_request.save!
    session['download_ar'] = @access_request.id
    redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
  end

  def preview
    @rendered_template = params[:rendered_template]
    @rendered_template ||= ''
    pdf = WickedPdf.new.pdf_from_string(@rendered_template, encoding: 'UTF-8')
    send_data(pdf, :type => :pdf, :disposition => 'inline')
  end

  def comment
    @ar = AccessRequest.find(params[:id])
    c = Comment.new
    c.content = params[:content]
    c.user = current_user
    @ar.comments << c
    if @ar.save
      @result = 'success'
    else
      @result = @ar.errors.full_messages.join(". ")
    end
  end
end
