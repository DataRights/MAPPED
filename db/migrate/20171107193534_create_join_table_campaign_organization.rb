class CreateJoinTableCampaignOrganization < ActiveRecord::Migration[5.1]
  def change
    create_join_table :campains, :organizations do |t|
       t.index [:campain_id, :organization_id]
       t.index [:organization_id, :campain_id]
    end
  end
end
