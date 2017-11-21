class CreateEmailNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :email_notifications do |t|
      t.references :notification, foreign_key: true
      t.integer :status, default: 0, null: false
      t.datetime :sent
      t.datetime :delivered

      t.timestamps
    end
  end
end
