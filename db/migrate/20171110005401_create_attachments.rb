class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :title
      t.string :content_type
      t.binary :content
      t.belongs_to :access_request, foreign_key: true

      t.timestamps
    end
  end
end
