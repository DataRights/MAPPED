class RevertEventIntoWorkflowState < ActiveRecord::Migration[5.1]
  def change
      remove_column :access_request_steps, :event_id
      drop_table :events, force: :cascade
  end
end
