class AddNotificationTypeToNotificationSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :notification_settings, :notification_type, :string
  end
end
