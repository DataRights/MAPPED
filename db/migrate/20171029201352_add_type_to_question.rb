class AddTypeToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :type, :string unless column_exists? :questions, :type
  end
end
