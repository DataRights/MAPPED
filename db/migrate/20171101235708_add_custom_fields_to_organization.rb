class AddCustomFieldsToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :custom_1, :text
    add_column :organizations, :custom_1_desc, :text
    add_column :organizations, :custom_2, :text
    add_column :organizations, :custom_2_desc, :text
    add_column :organizations, :custom_3, :text
    add_column :organizations, :custom_3_desc, :text
  end
end
