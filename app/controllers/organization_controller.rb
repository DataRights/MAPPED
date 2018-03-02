class OrganizationController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      @o = Organization.new(organization_params)
      @o.suggested_by_user_id = current_user.id
      @o.approved = false
      @o.sector = Sector.find_or_create_by name: 'Others'
      @o.campaigns << Campaign.find(params[:campaign_id])
      if @o.save
        @result = 'success'
      else
        @result = @o.errors.full_messages.join(". ")
      end
    rescue Exception => e
      @result = e.message
    end
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => { result: @result } }
    end
  end

  private
   def organization_params
     params.require(:organization).permit(:name, :privacy_policy_url, address_attributes: [:line1, :line2, :post_code, :city_name, :country_id, :email])
   end
end
