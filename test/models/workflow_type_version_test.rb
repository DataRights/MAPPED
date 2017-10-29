# == Schema Information
#
# Table name: workflow_type_versions
#
#  id               :integer          not null, primary key
#  version          :float
#  workflow_type_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class WorkflowTypeVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
