class AddPolicyConsentsToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_reference :campaigns, :policy_consent, foreign_key: true, null: true
  end
end
