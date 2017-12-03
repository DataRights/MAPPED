class CreateUserPolicyConsents < ActiveRecord::Migration[5.1]
  def change
    create_table :user_policy_consents do |t|
      t.references :user, foreign_key: true
      t.references :policy_consent, foreign_key: true
      t.boolean :approved
      t.datetime :approved_date
      t.datetime :revoked_date

      t.timestamps
    end
  end
end
