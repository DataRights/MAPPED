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

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "Notification should have default value of pending" do
     n = Notification.new
     n.user = users(:one)
     n.title = 'test'
     n.content = 'test'
     assert n.save, n.errors.messages
     n.reload
     assert_equal 'pending', n.status
  end
end
