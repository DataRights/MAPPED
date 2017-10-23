class CreateTransitions < ActiveRecord::Migration[5.1]
  def change
    create_table :transitions do |t|
      t.string :name
      t.references :from_state, foreign_key: { to_table: :workflow_states }, index: true
      t.references :to_state, foreign_key: { to_table: :workflow_states }, index: true

      t.timestamps
    end
  end
end
