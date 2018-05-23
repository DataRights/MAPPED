class AddSendingEnumMethodToAccessRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :access_requests, :sending_method_id, :integer
    add_column :access_requests, :sending_method, :string
  end
end
