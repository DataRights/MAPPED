class RemoveAttachmentAccessRecuestReference < ActiveRecord::Migration[5.1]
  def change
    remove_column :attachments, :access_request_id
  end
end
