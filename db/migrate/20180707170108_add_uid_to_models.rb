class AddUidToModels < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'
    add_column :access_requests, :uid, :uuid, default: 'gen_random_uuid()', null: false
    add_column :attachments, :uid, :uuid, default: 'gen_random_uuid()', null: false
  end
end
