class ChangeWorkflowTransitionColumnsToJsonb < ActiveRecord::Migration[5.1]
  def change
    remove_column :workflow_transitions, :performed_actions, :string
    remove_column :workflow_transitions, :rollback_failed_actions, :string
    add_column :workflow_transitions, :performed_actions, :jsonb
    add_column :workflow_transitions, :rollback_failed_actions, :jsonb
  end
end
