class AddDisplayOrderToTransitions < ActiveRecord::Migration[5.1]
  def change
    add_column :transitions, :display_order, :integer, default: 10
  end
end
