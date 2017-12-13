class CampaignsController < ApplicationController

  before_action :authenticate_user!

  def index
    @campaigns = Campaign.top_three
  end
end
