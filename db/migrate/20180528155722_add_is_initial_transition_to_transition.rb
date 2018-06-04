class AddIsInitialTransitionToTransition < ActiveRecord::Migration[5.1]
  def change
    add_column :transitions, :is_initial_transition, :boolean, default: false
  end
end
