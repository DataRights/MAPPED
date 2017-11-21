class CreateNotificationSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_settings do |t|
      t.string :name

      t.timestamps
    end
  end
end
