class DropReponseTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :responses
    drop_table :response_types
  end
end
