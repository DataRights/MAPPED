class RemoveSeenDateFromNotification < ActiveRecord::Migration[5.1]
  def change
    remove_column :notifications, :seen_date, :datetime
  end
end
