class AddLanguagesToCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :languages, :string, array:true, default: []
  end
end
