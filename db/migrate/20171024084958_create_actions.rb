class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.string :name
      t.string :description
      t.string :class_name
      t.string :type
      t.string :internal_data

      t.timestamps
    end
  end
end
