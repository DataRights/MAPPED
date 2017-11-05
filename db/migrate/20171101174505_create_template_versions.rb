class CreateTemplateVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :template_versions do |t|
      t.string :version
      t.references :template, foreign_key: true
      t.text :content
      t.boolean :active

      t.timestamps
    end
  end
end
