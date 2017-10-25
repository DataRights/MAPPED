class CreateAccessRights < ActiveRecord::Migration[5.1]
  def change
    create_table :access_rights do |t|
      t.string :action
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
