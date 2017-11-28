class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.top_three
  end
end
