require 'test_helper'

class TransitionTimeoutJobTest < ActiveJob::TestCase
  test "if possible job should execute the timeout transition for workflow" do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
    wf.access_request = access_requests(:one)
    wf.save!
    assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state

    transitions = wf.workflow_state.possible_transitions
    assert_equal 1, transitions.count
    t = transitions.first
    assert_equal transitions(:access_request_created), transitions.first
    assert_equal 1, t.timeout_days
    assert_equal t.from_state, wf.workflow_state
    assert_equal 0, WorkflowTransition.where(workflow_id: wf.id).count, WorkflowTransition.where(workflow_id: wf.id).first.inspect

    job = TransitionTimeoutJob.new
    job.perform(wf.id, wf.workflow_state.id, t.id)
    wt = WorkflowTransition.find_by(workflow_id: wf.id)
    assert wt
    assert_equal 'success', wt.status
    wf.reload
    assert_equal wf.workflow_state, t.to_state
  end
end
