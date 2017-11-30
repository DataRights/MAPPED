class CreateUserTermsOfServices < ActiveRecord::Migration[5.1]
  def change
    create_table :user_terms_of_services do |t|
      t.references :user, foreign_key: true
      t.references :terms_of_service, foreign_key: true
      t.boolean :approved
      t.datetime :approved_date

      t.timestamps
    end
  end
end
