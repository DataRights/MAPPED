class AddSectorTemplatesJoin < ActiveRecord::Migration[5.1]
  def change
    create_table :sectors_templates, id: false do |t|
      t.belongs_to :sector, index: true
      t.belongs_to :template, index: true
    end
  end
end
