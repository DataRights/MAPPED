class RemoveOraganizationTemplateJoin < ActiveRecord::Migration[5.1]
  def change
    drop_table(:organizations_templates, if_exists: true)
  end
end
