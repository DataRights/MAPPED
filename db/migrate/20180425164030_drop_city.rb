class DropCity < ActiveRecord::Migration[5.1]
  def change
    drop_table :cities, force: :cascade
  end
end
