class RemoveEventDescriptionFromWorkflowTransition < ActiveRecord::Migration[5.1]
  def change
    remove_column :workflow_transitions, :event_description
  end
end
