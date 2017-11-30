class AddTermsOfServiceToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_reference :campaigns, :terms_of_service, foreign_key: true, null: true
  end
end
