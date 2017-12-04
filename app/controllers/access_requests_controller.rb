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
  end

  def create
  end
end
