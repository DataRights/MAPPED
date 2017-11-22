class AddErrorLogToEmailNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :email_notifications, :error_log, :string
  end
end
