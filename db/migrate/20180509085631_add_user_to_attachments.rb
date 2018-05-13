class AddUserToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :user, foreign_key: true
  end
end
