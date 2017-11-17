class AddNotificationTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification_type, :integer, default: 1, null: false
  end
end
