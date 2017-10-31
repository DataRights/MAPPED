# == Schema Information
#
# Table name: workflows
#
#  id                       :integer          not null, primary key
#  workflow_type_version_id :integer
#  workflow_state_id        :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class WorkflowTest < ActiveSupport::TestCase
  test "Creating a new instance of a workflow sets it to inital state automatically" do
     wf = Workflow.new
     wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
     wf.save
     assert_equal workflow_states(:ar_created), wf.workflow_state
  end

  test 'Creating a new instance of a workflow for an inactive workflow type should return error!' do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:two)
    assert_not wf.save
    assert_equal 1, wf.errors.messages[:workflow_type_version].count, "There should be one error about workflow_type_version in code: #{wf.errors.messages[:workflow_type_version]}"
    assert_equal I18n.t('validations.workflow_type_should_be_active'), wf.errors.messages[:workflow_type_version].first
  end
end
