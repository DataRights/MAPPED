class AddRemarkToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :remark, :text
  end
end
