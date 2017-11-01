class AddOraganizationTemplateJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations_templates, id: false do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :templates, index: true
    end
  end
end
