class CreateWorkflowStates < ActiveRecord::Migration[5.1]
  def change
    create_table :workflow_states do |t|
      t.string :name
      t.references :workflow_type_version, foreign_key: true
      t.timestamps
    end
  end
end
