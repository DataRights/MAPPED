class AddPrivateContentToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :private_content, :boolean, default: false
  end
end
