class AddLanguagesToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :languages, :string, array:true, default: []
  end
end
