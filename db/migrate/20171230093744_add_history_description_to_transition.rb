class AddHistoryDescriptionToTransition < ActiveRecord::Migration[5.1]
  def change
    add_column :transitions, :history_description, :string
  end
end
