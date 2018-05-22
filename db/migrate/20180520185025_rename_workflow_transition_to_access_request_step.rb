class RenameWorkflowTransitionToAccessRequestStep < ActiveRecord::Migration[5.1]
  def change
      rename_column :correspondences, :workflow_transition_id, :access_request_step_id
      rename_table :workflow_transitions, :access_request_steps
      # rename index
  end
end
