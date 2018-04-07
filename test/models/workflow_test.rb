# == Schema Information
#
# Table name: workflows
#
#  id                       :integer          not null, primary key
#  workflow_type_version_id :integer
#  workflow_state_id        :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  access_request_id        :integer
#

require 'test_helper'

class WorkflowTest < ActiveSupport::TestCase
  test "Creating a new instance of a workflow sets it to inital state automatically" do
     wf = Workflow.new
     wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
     wf.save
     assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state
  end

  test 'Creating a new instance of a workflow for an inactive workflow type should return error!' do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:two)
    assert_not wf.save
    assert_equal 1, wf.errors.messages[:workflow_type_version].count, "There should be one error about workflow_type_version in code: #{wf.errors.messages[:workflow_type_version]}"
    assert_equal I18n.t('validations.workflow_type_should_be_active'), wf.errors.messages[:workflow_type_version].first
  end

  test "Using undo user should be able to rollback multiple transitions" do
    wt = workflow_transitions(:wt_data_came_back_transition)
    wf = wt.workflow
    assert_equal workflow_states(:data_came_back), wf.workflow_state

    result = wf.undo
    assert_equal true, result[:success], result[:message]
    assert_equal workflow_states(:waiting_for_the_organization_reply), wf.workflow_state

    result = wf.undo
    assert_equal true, result[:success], result[:message]
    assert_equal workflow_states(:waiting_to_send_the_ar), wf.workflow_state

    result = wf.undo
    assert_equal true, result[:success], result[:message]
    assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state
  end
end
