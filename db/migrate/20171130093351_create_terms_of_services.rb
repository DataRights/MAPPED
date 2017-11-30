class CreateTermsOfServices < ActiveRecord::Migration[5.1]
  def change
    create_table :terms_of_services do |t|
      t.references :template, foreign_key: true
      t.string :title, null: false
      t.integer :type_of, null: false
      t.boolean :mandatory, default: false

      t.timestamps
    end
  end
end
