class CreateWorkflowTypeVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :workflow_type_versions do |t|
      t.float :version
      t.references :workflow_type, foreign_key: true

      t.timestamps
    end
  end
end
