class AddVisualsToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :visuals, :jsonb
  end
end
