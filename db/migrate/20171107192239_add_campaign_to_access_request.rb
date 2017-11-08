class AddCampaignToAccessRequest < ActiveRecord::Migration[5.1]
  def change
    add_reference :access_requests, :campaign, index: true
  end
end
