class AddEmailToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :email, :string
  end
end
