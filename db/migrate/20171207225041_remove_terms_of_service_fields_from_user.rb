class RemoveTermsOfServiceFieldsFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :terms_of_service, :boolean
    remove_column :users, :terms_of_service_acceptance_date, :datetime
  end
end
