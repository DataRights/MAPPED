class AddTemplateVersionFieldsToTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :templates, :version, :string
    add_column :templates, :content, :text
    add_column :templates, :active,  :boolean
    add_column :templates, :language, :string
  end
end
