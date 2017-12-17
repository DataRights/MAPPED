# == Schema Information
#
# Table name: campaigns
#
#  id                   :integer          not null, primary key
#  name                 :string
#  short_description    :string
#  expanded_description :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  policy_consent_id    :integer
#  workflow_type_id     :integer
#

require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name'=>'campaign1', 'short_description'=>'a campaign', 'expanded_description'=>'a very important campaign'}), Campaign.new(name: 'campaign1', short_description: 'a campaign', expanded_description: 'a very important campaign').context_value
  end

  test 'Top three campaigns should load from cache and and adding new campaigns should invalidate the cache' do
    Rails.cache.delete(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME)
    assert_equal false, Rails.cache.exist?(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME)
    Campaign.top_three # first time does not read from cache
    Campaign.top_three # Second call reads from caches_action :action
    assert_equal true, Rails.cache.exist?(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME)
    c = Campaign.new
    c.name = 'Test campaign'
    c.short_description = 'This is a campaign to test top_three cache items update'
    c.expanded_description = 'This is a campaign to test top_three cache items update, blah blah ...'
    c.workflow_type = workflow_types(:one)
    assert c.save
    assert_equal false, Rails.cache.exist?(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME)
    Campaign.top_three
    assert_equal true, Rails.cache.exist?(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME)
  end
end
