class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :access_request, foreign_key: true
      t.string :title
      t.string :content
      t.integer :status, default: 0, null: false
      t.datetime :seen_date

      t.timestamps
    end
  end
end
