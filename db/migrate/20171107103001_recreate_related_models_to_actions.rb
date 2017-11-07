class RecreateRelatedModelsToActions < ActiveRecord::Migration[5.1]
  def change
    create_table :code_actions do |t|
      t.string :name
      t.string :description
      t.string :class_name
      t.string :method_name
      t.timestamps
    end

    create_table :transitions do |t|
      t.string :name
      t.references :from_state, foreign_key: { to_table: :workflow_states }, index: true
      t.references :to_state, foreign_key: { to_table: :workflow_states }, index: true
      t.timestamps
    end

    create_join_table :code_actions, :transitions do |t|
      t.index [:code_action_id, :transition_id], name: "index_actions_transitions_on_action_id_and_transition_id"
    end

    create_join_table :guards, :transitions do |t|
      t.index [:guard_id, :transition_id]
    end

    create_table :workflow_transitions do |t|
      t.references :workflow, foreign_key: true
      t.references :transition, foreign_key: true
      t.references :failed_action, foreign_key: { to_table: :code_actions }, index: true
      t.references :failed_guard, foreign_key: { to_table: :guards }, index: true
      t.string :action_failed_message
      t.string :failed_guard_message
      t.string :status
      t.jsonb :rollback_failed_actions
      t.jsonb :performed_actions
      t.jsonb :internal_data
      t.timestamps
    end
  end
end
