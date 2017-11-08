class AddCampaignsOrganizationsJoin < ActiveRecord::Migration[5.1]
  def change
    create_join_table :campaigns, :organizations do |t|
       #t.index [:campaign_id, :organization_id]
       #t.index [:organization_id, :campaign_id]
    end
  end
end
