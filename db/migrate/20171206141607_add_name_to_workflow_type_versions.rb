class AddNameToWorkflowTypeVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :workflow_type_versions, :name, :string, null: false, default: '-'
  end
end
