class CreateWorkflowStateForms < ActiveRecord::Migration[5.1]
  def change
    create_table :workflow_state_forms do |t|
      t.string :name
      t.string :form_path

      t.timestamps
    end
  end
end
