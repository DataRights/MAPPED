class AddSendingMethodToAccessRequests < ActiveRecord::Migration[5.1]
  def change
    add_reference :access_requests, :sending_method, foreign_key: true
    add_column :access_requests, :sending_method_remarks, :string
  end
end
