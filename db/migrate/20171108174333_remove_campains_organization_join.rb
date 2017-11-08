class RemoveCampainsOrganizationJoin < ActiveRecord::Migration[5.1]
  def change
     drop_table(:campains_organizations, if_exists: true)
  end
end
