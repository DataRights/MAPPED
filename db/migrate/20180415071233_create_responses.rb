class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.references :response_type, foreign_key: true
      t.text :description
      t.datetime :received_date
      t.references :access_request, foreign_key: true

      t.timestamps
    end
  end
end
