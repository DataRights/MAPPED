class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.references :sector, foreign_key: true

      t.timestamps
    end
  end
end
