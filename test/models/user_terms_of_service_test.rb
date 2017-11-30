# == Schema Information
#
# Table name: user_terms_of_services
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  terms_of_service_id :integer
#  approved            :boolean
#  approved_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class UserTermsOfServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
