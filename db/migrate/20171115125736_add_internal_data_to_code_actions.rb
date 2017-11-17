class AddInternalDataToCodeActions < ActiveRecord::Migration[5.1]
  def change
    add_column :code_actions, :internal_data, :jsonb
  end
end
