# == Schema Information
#
# Table name: workflow_states
#
#  id                       :integer          not null, primary key
#  name                     :string
#  workflow_type_version_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class WorkflowStateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
