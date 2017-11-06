class AddLanguageToTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :template_versions, :language, :string
  end
end
