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

  enum status: [:pending, :seen]
end
