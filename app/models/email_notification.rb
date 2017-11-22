# == Schema Information
#
# Table name: email_notifications
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  status          :integer          default("pending"), not null
#  sent            :datetime
#  delivered       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email_type      :integer          default("instantly"), not null
#

class EmailNotification < ApplicationRecord
  belongs_to :notification
  enum status: [:pending, :sent, :delivered, :failed]
  enum email_type: [:instantly, :daily, :weekly]
  delegate :user, to: :notification

  after_create :send_single_email

  def send_single_email
    if email_type == 'instantly'
      UserMailer.notification(self.id).deliver_later
    end
  end

  def self.send_daily_digest
    # Rails has a bug with symbols in nested joins have to send integer instead of an enum symbol
    # https://github.com/rails/rails/issues/25128
    # send_daily_digest
    EmailNotification.send_digest(1)
  end

  def self.send_weekly_digest
    # Rails has a bug with symbols in nested joins have to send integer instead of an enum symbol
    # https://github.com/rails/rails/issues/25128
    EmailNotification.send_digest(2)
  end

  def self.send_digest(type)
    # Rails has a bug with symbols in nested joins
    # https://github.com/rails/rails/issues/25128
    users = User.joins([:notifications => :email_notifications]).where(email_notifications: {status: 0, email_type: type}).uniq
    users.each do |u|
      email_notification_ids = EmailNotification.joins(:notification).where(status: 0, notifications: {user_id: u.id}).pluck(:id)
      UserMailer.digest_notification(u.email, email_notification_ids).deliver_later if email_notification_ids.count > 0
    end
  end
end
