class CreateAccessRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :access_requests do |t|
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true
      t.jsonb :meta_data
      t.datetime :sent_date
      t.datetime :data_received_date

      t.timestamps
    end
  end
end
