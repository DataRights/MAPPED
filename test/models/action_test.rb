# == Schema Information
#
# Table name: actions
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :string
#  class_name    :string
#  type          :string
#  internal_data :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  method_name   :string
#

require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
