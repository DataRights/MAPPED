class AddTransitionTypeToTransitiosn < ActiveRecord::Migration[5.1]
  def change
    add_column :transitions, :transition_type, :integer, default: 0
  end
end
