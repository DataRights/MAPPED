class CreateJoinTableActionTransition < ActiveRecord::Migration[5.1]
  def change
    create_join_table :actions, :transitions do |t|
      t.index [:action_id, :transition_id]
    end
  end
end
