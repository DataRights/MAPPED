class AddResponseToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :response, foreign_key: true
  end
end
