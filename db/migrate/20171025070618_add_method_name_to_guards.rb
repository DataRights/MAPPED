class AddMethodNameToGuards < ActiveRecord::Migration[5.1]
  def change
    add_column :guards, :method_name, :string
  end
end
