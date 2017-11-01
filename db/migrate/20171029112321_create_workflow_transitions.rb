class CreateWorkflowTransitions < ActiveRecord::Migration[5.1]
  def change
    create_table :workflow_transitions do |t|
      t.references :workflow, foreign_key: true
      t.references :transition, foreign_key: true
      t.references :failed_action, foreign_key: { to_table: :actions }, indxe: true
      t.references :failed_guard, foreign_key: { to_table: :guards }, indxe: true
      t.string :action_failed_message
      t.string :failed_guard_message
      t.string :status
      t.string :rollback_failed_actions
      t.string :performed_actions
      t.jsonb :internal_data

      t.timestamps
    end
  end
end
