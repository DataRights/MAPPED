# == Schema Information
#
# Table name: web_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  status          :integer          default("pending"), not null
#  seen_date       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class WebNotification < ApplicationRecord
  belongs_to :notification

  enum status: [:unread, :seen]
  after_save :update_unread_cache

  def self.unread_web_notifications(user_id)
    Rails.cache.fetch("notifications/#{user_id}/unread_count", expires_in: 180.minutes) do
      WebNotification.joins(:notification).where(status: :unread, notifications: {user_id: user_id}).count
    end
  end

  def update_unread_cache
    Rails.cache.delete("notifications/#{self.notification.user_id}/unread_count")
  end
end
