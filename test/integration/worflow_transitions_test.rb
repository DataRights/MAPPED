require 'test_helper'

class WorflowTransitionsTest < ActionDispatch::IntegrationTest
  test "User should be able to create a workflow for access request and go through transitions" do
     wf = Workflow.new
     wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
     wf.save!
     assert_equal workflow_states(:ar_created), wf.workflow_state

    transitions = wf.workflow_state.possible_transitions
    assert_equal 1, transitions.count

    wt = wf.send_event(transitions.first)
    assert_equal 'success', wt.status
    assert_equal wf.workflow_state, transitions.first.to_state
  end

  test "Workflow.send_event should raise an error if transition is not between possible transitions for current state" do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
    wf.save!
    assert_equal workflow_states(:ar_created), wf.workflow_state
    exception = assert_raises(Exception) { wf.send_event(transitions(:data_came_back)) }
    assert_equal( I18n.t('errors.transition_does_not_exist_in_current_state'), exception.message )
  end

  test "Test actions and guards success scenario" do
    
  end
end
