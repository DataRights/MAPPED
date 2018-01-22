# == Schema Information
#
# Table name: user_policy_consents
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  policy_consent_id :integer
#  approved          :boolean
#  approved_date     :datetime
#  revoked_date      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  content           :text
#

require 'test_helper'

class UserPolicyConsentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'approved and revoked should update the value of approved_date and revoke' do
    upc = user_policy_consents(:four)
    assert_not upc.approved
    assert upc.approved_date.nil?
    assert upc.revoked_date.nil?
    upc.approved = true
    assert upc.save
    assert upc.approved_date
    assert_nil upc.revoked_date
    upc.approved = false
    assert upc.save
    assert upc.revoked_date
    assert upc.approved_date
    assert_equal false, upc.approved
  end
end
