# == Schema Information
#
# Table name: transitions
#
#  id            :integer          not null, primary key
#  name          :string
#  from_state_id :integer
#  to_state_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class TransitionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
