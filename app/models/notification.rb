# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  access_request_id :integer
#  title             :string
#  content           :string
#  status            :integer          default("pending")
#  seen_date         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :access_request, optional: true
  enum status: [:pending, :email_sent, :seen]
  after_create :send_realtime_notification

  def send_realtime_notification
    if self.user.notification_type == 'email_realtime'
      UserMailer.notification(self.user.email, self.title, self.content).deliver_later
      self.status = :email_sent
      self.save!
    end
  end

  def self.send_daily_digest
    # User.joins(:notifications).where(users: {notification_type: :email_daily_digest}, notifications: {status: :pending})

    daily_users = User.where(notification_type: :email_daily_digest)
    daily_users.each do |u|
      notifications = u.notifications.where(status: :pending)
      UserMailer.digest_notification(u.email, notifications.to_json).deliver_later
      notifications.update_all(status: :email_sent, updated_at: Time.now)
    end
  end

  def self.send_weekly_digest
    weekly_users = User.where(notification_type: :email_weekly_digest)
    weekly_users.each do |u|
      notifications = u.notifications.where(status: :pending)
      UserMailer.digest_notification(u.email, notifications.to_json).deliver_later
      notifications.update_all(status: :email_sent, updated_at: Time.now)
    end
  end
end
