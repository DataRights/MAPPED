# == Schema Information
#
# Table name: correspondences
#
#  id                     :integer          not null, primary key
#  final_text             :string
#  remarks                :string
#  access_request_step_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  correspondence_type    :string
#  medium                 :string
#  direction              :string
#  correspondence_date    :datetime
#  access_request_id      :integer
#

require 'test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
