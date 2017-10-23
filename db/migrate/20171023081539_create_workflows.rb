class CreateWorkflows < ActiveRecord::Migration[5.1]
  def change
    create_table :workflows do |t|
      t.references :workflow_type_version, foreign_key: true
      t.references :workflow_state, foreign_key: true

      t.timestamps
    end
  end
end
