class AddCustomFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :custom_1, :text
    add_column :users, :custom_2, :text
    add_column :users, :custom_3, :text
  end
end
