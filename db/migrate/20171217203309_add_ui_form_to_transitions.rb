class AddUiFormToTransitions < ActiveRecord::Migration[5.1]
  def change
    add_column :transitions, :ui_form, :integer, null: true
  end
end
