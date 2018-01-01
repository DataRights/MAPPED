class RemoveUniqueIndexFromTransition < ActiveRecord::Migration[5.1]
  def change
    begin
      remove_index :transitions, [:from_state_id, :to_state_id]
    rescue
      print 'No index found with the specified name.'
    end
  end
end
