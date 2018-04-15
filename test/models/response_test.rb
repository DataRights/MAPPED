# == Schema Information
#
# Table name: responses
#
#  id                :integer          not null, primary key
#  response_type_id  :integer
#  description       :text
#  received_date     :datetime
#  access_request_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
