class AddDisplayOrderToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :display_order, :integer
  end
end
