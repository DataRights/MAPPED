class AddEventDescriptionAndRemarksToWorkflowTransition < ActiveRecord::Migration[5.1]
  def change
    add_column :workflow_transitions, :event_description, :string
    add_column :workflow_transitions, :remarks, :string
  end
end
