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
        flash[:alert] = I18n.t('access_requests.index.approving_campaign_policy_consent_mandatory')
        redirect_to user_profile_for_campaign_path(@campaign) and return
      end
    end

    @access_requests = current_user.access_requests.includes(:campaign, :comments, organization: [:sector, address: [:country]], workflow: [{workflow_state: [:workflow_state_form, :possible_transitions]}, {access_request_steps: [:transition] }]).where(campaign_id: @campaign.id).order('created_at DESC')
    @download_ar = nil
    if session['download_ar']
      @download_ar = session['download_ar']
      session['download_ar'] = nil
    end
  end

  def new
    @access_request = AccessRequest.new
    @access_request.ar_method = 'template'
    @organization = Organization.new
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
    return unless @selected_organization
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
    # unless @rendered_template
    #   flash[:notice] = I18n.t('errors.template_version_not_found')
    #   redirect_to home_path and return
    # end
    @access_request.final_text = @rendered_template
  end

  def create
    success = false
    ActiveRecord::Base.transaction do
      @access_request = AccessRequest.new(access_request_params)
      @access_request.user = current_user

      if @access_request.ar_method == 'upload'
        @access_request.final_text = nil
        attachment = Attachment.new
        attachment.content = @access_request.uploaded_access_request_file&.read
        attachment.content_type = @access_request.uploaded_access_request_file&.content_type
        attachment.title = @access_request.uploaded_access_request_file&.original_filename
        attachment.user = current_user
        if attachment.save
          @access_request.attachment_id = attachment.id
        else
          flash[:alert] = attachment.errors.full_messages.join('. ')
          raise ActiveRecord::Rollback
        end
      end

      if @access_request.save
        session['download_ar'] = @access_request.id unless @access_request.ar_method == 'upload'
        success = true
      else
        flash[:alert] = @access_request.errors.messages.values.join(',')
        raise ActiveRecord::Rollback
      end
    end

    if success
      redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
    else
      redirect_to new_campaign_access_request_path(@access_request.campaign_id)
    end
  end

  def edit
    @campaign = @access_request.campaign
    @campaign_count = AccessRequest.where('campaign_id = ? AND user_id = ?', @campaign.id,current_user.id).count
    @sectors = get_sectors(@campaign)
    @templates = []
    @selected_organization = @access_request.organization.id
    @selected_sector = @access_request.organization.sector
    @selected_template = nil
    @organizations = get_campaign_organizations(@campaign, @selected_sector)
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

    if @access_request.has_file?
      @access_request.ar_method = 'upload'
      @rendered_template = AccessRequest.get_rendered_template(:access_request, current_user, @campaign, @access_request.organization, @access_request, @selected_template)
      @access_request.final_text = @rendered_template # in case users decided to change everything and use text instead of their file
    else
      @access_request.ar_method = 'template'
      @access_request.final_text = @access_request.ar_text 
      @rendered_template = @access_request.ar_text
    end
  end

  def update
    success = false
    ActiveRecord::Base.transaction do
      @access_request.assign_attributes(access_request_params)
      if @access_request.ar_method == 'upload'
        @access_request.final_text = nil
        attachment = nil
        if @access_request.has_file?
          attachment = @access_request.ar_attachment
        else
          attachment = Attachment.new
          attachment.user = current_user
        end
        attachment.content = @access_request.uploaded_access_request_file&.read
        attachment.content_type = @access_request.uploaded_access_request_file&.content_type
        attachment.title = @access_request.uploaded_access_request_file&.original_filename
        if attachment.save
          @access_request.attachment_id = attachment.id
        else
          flash[:alert] = attachment.errors.full_messages.join(". ")
          raise ActiveRecord::Rollback
        end
      elsif @access_request.final_text
        @access_request.uploaded_access_request_file = nil
      end

      if @access_request.save
        session['download_ar'] = @access_request.id
        success = true
      else
        flash[:alert] = @access_request.errors.messages.values.join(',')
        raise ActiveRecord::Rollback
      end
    end

    if success
      redirect_to campaign_access_requests_path(campaign_id: @access_request.campaign_id)
    else
      redirect_to edit_campaign_access_request_path(campaign_id: @access_request.campaign_id, id: @access_request.id)
    end
  end

  def preview
    @rendered_template = params[:rendered_template]
    @rendered_template ||= ''
    pdf = WickedPdf.new.pdf_from_string(@rendered_template, encoding: 'UTF-8')
    send_data(pdf, :type => :pdf, :disposition => 'inline')
  end

  def download
    if @access_request.ar_attachment
      send_data(@access_request.ar_attachment.content, :filename => "AccessRequest-#{@access_request.id}-#{@access_request.organization.name}", :type => @access_request.ar_attachment.content_type)
    else
      pdf = WickedPdf.new.pdf_from_string(@access_request.ar_text&.html_safe, encoding: 'UTF-8')
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
     params.require(:access_request).permit(:organization_id, :campaign_id, :final_text, :uploaded_access_request_file, :ar_method, :private_attachments)
   end

   def find_access_request
    @access_request = AccessRequest.find(params[:id])
    unless @access_request.user_id == current_user.id
      raise "Access Request does not belong to your user: #{@access_request.user_id} != #{current_user.id}"
    end
   end
end
