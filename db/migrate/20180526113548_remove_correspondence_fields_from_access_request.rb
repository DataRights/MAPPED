class RemoveCorrespondenceFieldsFromAccessRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :access_requests, :data_received_date, :datetime
    remove_column :access_requests, :sent_date, :datetime
    remove_column :access_requests, :suggested_text, :text
    remove_column :access_requests, :final_text, :text
  end
end
