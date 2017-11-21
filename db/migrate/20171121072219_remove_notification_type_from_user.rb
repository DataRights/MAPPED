class RemoveNotificationTypeFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :notification_type, :integer
  end
end
