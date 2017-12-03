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
#

require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name'=>'campaign1', 'short_description'=>'a campaign', 'expanded_description'=>'a very important campaign'}), Campaign.new(name: 'campaign1', short_description: 'a campaign', expanded_description: 'a very important campaign').context_value
  end
end
