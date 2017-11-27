class AddTermsOfServiceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :terms_of_service, :boolean, default: false
    add_column :users, :terms_of_service_acceptance_date, :datetime
  end
end
