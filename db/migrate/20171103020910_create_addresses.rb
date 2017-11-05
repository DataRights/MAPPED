class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :post_code
      t.references :city, foreign_key: true
      t.references :country, foreign_key: true
      t.references :addressable, polymorphic: true, index: true
      
      t.timestamps
    end
  end
end
