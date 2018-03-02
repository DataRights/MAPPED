class AddPrivacyPolicyUrlToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :privacy_policy_url, :string
    add_column :organizations, :approved, :boolean, default: true
    add_reference :organizations, :suggested_by_user, foreign_key: { to_table: :users }
  end
end
