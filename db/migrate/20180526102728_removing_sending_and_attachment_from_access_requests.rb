class RemovingSendingAndAttachmentFromAccessRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :access_requests, :access_request_file, :binary
    remove_column :access_requests, :access_request_file_content_type, :string
    remove_column :access_requests, :sending_method_remarks, :string
    remove_column :access_requests, :sending_method, :string
  end
end
