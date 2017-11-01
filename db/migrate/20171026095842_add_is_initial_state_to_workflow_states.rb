class AddIsInitialStateToWorkflowStates < ActiveRecord::Migration[5.1]
  def change
    add_column :workflow_states, :is_initial_state, :boolean, default: false
  end
end
