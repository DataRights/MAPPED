class AddContentToUserPolicyConsent < ActiveRecord::Migration[5.1]
  def change
    add_column :user_policy_consents, :content, :text
  end
end
