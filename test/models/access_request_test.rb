# == Schema Information
#
# Table name: access_requests
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  user_id            :integer
#  meta_data          :jsonb
#  sent_date          :datetime
#  data_received_date :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  campaign_id        :integer
#  suggested_text     :text
#  final_text         :text
#

require 'test_helper'

class AccessRequestTest < ActiveSupport::TestCase
  test "Creating new access request should update count_of_access_requests in campaign" do
    campaign = campaigns(:one)
    old_count = campaign.count_of_access_requests
    assert_equal old_count, campaign.count_of_access_requests
    a = access_requests(:one)
    a.campaign = campaign
    assert a.save
    assert_equal old_count + 1, campaign.count_of_access_requests
  end
end
