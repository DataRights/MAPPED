class AddWorkflowTypeToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_reference :campaigns, :workflow_type, foreign_key: true
  end
end
