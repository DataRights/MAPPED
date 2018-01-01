class AddEventToWorkflowTransition < ActiveRecord::Migration[5.1]
  def change
    add_reference :workflow_transitions, :event, foreign_key: true
  end
end
