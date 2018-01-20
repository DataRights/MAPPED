class ConsentsController < ApplicationController
  def index
  end

  def show
  end

  def revoke
    upc = UserPolicyConsent.find params[:id]
    upc.approved = false
    upc.revoked_date = Time.now
    upc.save!
    redirect_to consents_index_path
  end
end
