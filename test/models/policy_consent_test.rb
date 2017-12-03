# == Schema Information
#
# Table name: policy_consents
#
#  id          :integer          not null, primary key
#  template_id :integer
#  title       :string           not null
#  type_of     :integer          not null
#  mandatory   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PolicyConsentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
