class ConsentsController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def show
  end

  def revoke
    upc = UserPolicyConsent.find params[:id]
    unless upc.user_id == current_user.id
      redirect_to consents_index_url and return
    end
    upc.approved = false
    upc.revoked_date = Time.now
    upc.save!
    redirect_to consents_index_path
  end
end
