class AddCampaignUserAssociation < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :campaigns do |t|
      t.index [:user_id, :campaign_id]
    end
  end
end
