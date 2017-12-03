class AccessRequestsController < ApplicationController
  def index
  end

  def new
    campaign_id = params[:campaign_id]
    campaign_id = Campaign.find_by(:name => 'Default') unless campaign_id
    unless campaign_id
      flash[:notice] = I18n.t('errors.campaign_not_found')
      redirect_to home_path and return
    end
    @campaign = Campaign.find_by_id  campaign_id
    unless @campaign
      flash[:notice] = I18n.t('errors.campaign_not_found')
      redirect_to home_path and return
    end
    @campaign_name = @campaign.name
    @campaign_count = AccessRequest.where('campaign_id = ? AND user_id = ?', @campaign.id,current_user.id).count
    @campaign_desc = @campaign.expanded_description
  end

  def create
  end
end
