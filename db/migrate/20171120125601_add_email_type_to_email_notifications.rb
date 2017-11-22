class AddEmailTypeToEmailNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :email_notifications, :email_type, :integer, null: false, default: 0
  end
end
