class CampaignsController < ApplicationController
  include AccessRequestsHelper

  def index
    @campaigns = Campaign.top_three
  end

  def get_organizations
    result = []
    campaign_id = params[:id]
    if campaign_id
      campaign = Campaign.find_by_id campaign_id
      if campaign
        sector_id = params[:sector_id]
        result = get_campaign_organizations(campaign, Sector.find_by_id(sector_id)) if sector_id
      end
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end
end
