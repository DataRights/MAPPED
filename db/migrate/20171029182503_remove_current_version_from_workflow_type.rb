class RemoveCurrentVersionFromWorkflowType < ActiveRecord::Migration[5.1]
  def change
    remove_column :workflow_types, :active_version, :float
  end
end
