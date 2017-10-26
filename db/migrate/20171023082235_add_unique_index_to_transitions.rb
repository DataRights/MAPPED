class AddUniqueIndexToTransitions < ActiveRecord::Migration[5.1]
  def change
    add_index :transitions, [:from_state_id, :to_state_id], unique: true
  end
end
