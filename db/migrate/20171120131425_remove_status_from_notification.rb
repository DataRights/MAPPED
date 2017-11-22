class RemoveStatusFromNotification < ActiveRecord::Migration[5.1]
  def change
    remove_column :notifications, :status, :integer
  end
end
