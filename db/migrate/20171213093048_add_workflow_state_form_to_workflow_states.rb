class AddWorkflowStateFormToWorkflowStates < ActiveRecord::Migration[5.1]
  def change
    add_reference :workflow_states, :workflow_state_form, foreign_key: true
  end
end
