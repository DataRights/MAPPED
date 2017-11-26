class AddAttachmentWorkflowTransitionReference < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :workflow_transition, foreign_key: true
  end
end
