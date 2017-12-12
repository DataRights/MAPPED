class AccessRequestsController < ApplicationController

  before_action :authenticate_user!

  def index
    @campaign = Campaign.find_by id: params[:campaign_id]
    @access_requests = current_user.access_requests.where(campaign_id: @campaign.id)
  end

  def new
  end

  def create
  end
end
