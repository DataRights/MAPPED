# == Schema Information
#
# Table name: access_requests
#
#  id                  :integer          not null, primary key
#  organization_id     :integer
#  user_id             :integer
#  meta_data           :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  campaign_id         :integer
#  private_attachments :boolean          default(FALSE)
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

    b = access_requests(:two)
    b.campaign = campaign
    assert b.save
    assert_equal old_count + 2, campaign.count_of_access_requests
  end

  test "Creating new access requests should update count_of_access_requests_by_user in campaign" do
    campaign = campaigns(:one)
    u = users(:one)
    old_count = campaign.count_of_access_requests_by_user(u)
    a = access_requests(:one)
    a.campaign = campaign
    a.user = u
    assert a.save
    assert_equal old_count + 1, campaign.count_of_access_requests_by_user(u)

    b = access_requests(:two)
    b.campaign = campaign
    b.user = u
    assert b.save
    assert_equal old_count + 2, campaign.count_of_access_requests_by_user(u)
  end
end
