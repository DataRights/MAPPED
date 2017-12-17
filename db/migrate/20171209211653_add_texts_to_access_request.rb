class AddTextsToAccessRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :access_requests, :suggested_text, :text
    add_column :access_requests, :final_text, :text
  end
end
