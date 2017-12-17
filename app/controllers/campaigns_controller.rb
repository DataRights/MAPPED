class CampaignsController < ApplicationController

  before_action :authenticate_user!
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

    template_version = get_campaign_org_template(current_user, campaign, organization)
    render json: result and return unless template_version

    context = TemplateContext.new
    context.campaign = campaign
    context.user = current_user
    context.organization = organization
    result = template_version.render(context)

    render :json => { :success => true, :template => result }
  end
end
