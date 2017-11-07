require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name'=>'campaign1', 'short_description'=>'a campaign', 'expanded_description'=>'a very important campaign'}), Campaign.new(name: 'campaign1', short_description: 'a campaign', expanded_description: 'a very important campaign').context_value
  end
end
