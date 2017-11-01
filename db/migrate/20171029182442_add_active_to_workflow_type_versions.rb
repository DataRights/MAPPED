class AddActiveToWorkflowTypeVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :workflow_type_versions, :active, :boolean, default: false
  end
end
