class DropResponseAndWorkflowFromAttachments < ActiveRecord::Migration[5.1]
  def change
    remove_column :attachments, :workflow_transition_id
    remove_column :attachments, :response_id
  end
end
