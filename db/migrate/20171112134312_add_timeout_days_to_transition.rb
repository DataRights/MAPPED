class AddTimeoutDaysToTransition < ActiveRecord::Migration[5.1]
  def change
    add_column :transitions, :timeout_days, :float
  end
end
