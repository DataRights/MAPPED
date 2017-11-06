class AddAccessRequestToWorkflow < ActiveRecord::Migration[5.1]
  def change
    add_reference :workflows, :access_request, foreign_key: true
  end
end
