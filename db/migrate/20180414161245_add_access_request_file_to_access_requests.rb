class AddAccessRequestFileToAccessRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :access_requests, :access_request_file, :binary
    add_column :access_requests, :access_request_file_content_type, :string
  end
end
