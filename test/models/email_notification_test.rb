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
#  error_log       :string
#

require 'test_helper'

class EmailNotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
