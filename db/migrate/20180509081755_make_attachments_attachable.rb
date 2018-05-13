class MakeAttachmentsAttachable < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :attachable, polymorphic: true, index: true
  end
end
