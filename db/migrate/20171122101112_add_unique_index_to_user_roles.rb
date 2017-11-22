class AddUniqueIndexToUserRoles < ActiveRecord::Migration[5.1]
  def change
    add_index(:user_roles, [:user_id, :role_id], unique: true)
  end
end
