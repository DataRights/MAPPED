class CreateJoinTableGuardsTransitions < ActiveRecord::Migration[5.1]
  def change
    create_join_table :guards, :transitions do |t|
      t.index [:guard_id, :transition_id]
    end
  end
end
