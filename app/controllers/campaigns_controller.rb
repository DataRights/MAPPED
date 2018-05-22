class CampaignsController < ApplicationController

  before_action :authenticate_user!
  include AccessRequestsHelper

  def index
    @campaigns = Campaign.top_three
    @requests_sent = AccessRequest.cached_count
    @responses = 0 # ??
    @participants = User.cached_count
    @organizations = Organization.cached_count
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

  def get_organization_template
    result = ''
    render json: result and return unless current_user
    campaign_id = params[:id]
    render json: result and return unless campaign_id
    campaign = Campaign.find_by_id campaign_id
    render json: result and return unless campaign
    organization_id = params[:organization_id]
    render json: result and return unless organization_id
    organization = Organization.find_by_id organization_id
    render json: result and return unless organization

    render json: result and return unless params.include?(:template_id) and params[:template_id] != 'null'
    template = params.include?(:template_id) ? Template.find(params[:template_id]) : nil

    rendered_template = AccessRequest.get_rendered_template(:access_request, current_user, campaign, organization, nil, template)
    if rendered_template
      render :json => { :success => true, :template => rendered_template }
    else
      render json: result
    end
  end
end
