class AddTagTable < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :tagable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
