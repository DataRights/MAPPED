class AddDescriptionToPolicyConsents < ActiveRecord::Migration[5.1]
  def change
      add_column :policy_consents, :description, :string
  end
end
