class AccessRequestsController < ApplicationController
  include AccessRequestsHelper

  before_action :authenticate_user!

  def index
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
    template_version = get_campaign_org_template(current_user, @campaign, organization)
    unless template_version
      flash[:notice] = I18n.t('errors.template_version_not_found')
      redirect_to home_path and return
    end

    context = TemplateContext.new
    context.campaign = @campaign
    context.user = current_user
    context.organization = organization

    @rendered_template = template_version.render(context)
  end

  def create
  end
end
