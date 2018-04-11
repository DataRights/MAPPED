class AddUiFormToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :ui_form, :integer
  end
end
