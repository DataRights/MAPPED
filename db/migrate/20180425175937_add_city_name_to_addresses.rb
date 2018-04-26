class AddCityNameToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :city_name, :string
  end
end
