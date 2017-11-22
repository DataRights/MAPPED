# == Schema Information
#
# Table name: notification_settings
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NotificationSetting < ApplicationRecord
  has_and_belongs_to_many :users
end
