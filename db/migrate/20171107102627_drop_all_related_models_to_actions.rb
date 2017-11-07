class DropAllRelatedModelsToActions < ActiveRecord::Migration[5.1]
  def change
    drop_table :workflow_transitions
    drop_table :actions_transitions
    drop_table :guards_transitions
    drop_table :transitions
  end
end
