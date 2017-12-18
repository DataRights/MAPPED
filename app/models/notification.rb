# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  access_request_id :integer
#  title             :string
#  content           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :access_request, optional: true
  has_many :email_notifications, dependent: :destroy
  has_many :web_notifications, dependent: :destroy
  after_create :create_notification_senders

  # TODO: factory for creating web, email, ... notifications
  def create_notification_senders
    user.notification_settings.each do |n|
      case n.notification_type
      when 'web_notification'
        WebNotification.create!(notification_id: self.id)
      when 'email_instantly'
        EmailNotification.create!(notification_id: self.id, email_type: :instantly)
      when 'email_daily_digest'
        EmailNotification.create!(notification_id: self.id, email_type: :daily)
      when 'email_weekly_digest'
        EmailNotification.create!(notification_id: self.id, email_type: :weekly)
      end
    end
  end
end
