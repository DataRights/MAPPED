class CreateJoinTableNotificationSettingUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :notification_settings, :users do |t|
      t.index [:user_id, :notification_setting_id], name: "index_user_notification_setting"
    end
  end
end
