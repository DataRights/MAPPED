class CreateSendingMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :sending_methods do |t|
      t.string :name

      t.timestamps
    end
  end
end
