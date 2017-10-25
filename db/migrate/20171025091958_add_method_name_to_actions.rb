class AddMethodNameToActions < ActiveRecord::Migration[5.1]
  def change
    add_column :actions, :method_name, :string
  end
end
