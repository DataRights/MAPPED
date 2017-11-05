class AddTemplateTypesToTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :templates, :template_type, :integer
  end
end
