# == Schema Information
#
# Table name: notification_settings
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :string
#

require 'test_helper'

class NotificationSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
