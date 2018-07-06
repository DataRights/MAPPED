class AddPrivacyLevel < ActiveRecord::Migration[5.1]
  def change
    add_column :access_requests, :private_attachments, :boolean, default: false
  end
end
