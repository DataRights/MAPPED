class CreateWebNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :web_notifications do |t|
      t.references :notification, foreign_key: true
      t.integer :status, default: 0, null: false, default: 0
      t.datetime :seen_date

      t.timestamps
    end
  end
end
