require 'test_helper'

class WorflowTransitionsTest < ActionDispatch::IntegrationTest
  test "User should be able to create a workflow for access request and go through transitions" do
     wf = Workflow.new
     wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
     wf.access_request = access_requests(:one)
     wf.save!
     assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state

    transitions = wf.workflow_state.possible_transitions
    assert_equal 1, transitions.count
    assert_equal transitions(:access_request_created), transitions.first

    wt = wf.send_event(transitions(:access_request_created))
    assert_equal 'success', wt.status
    assert_equal wf.workflow_state, transitions.first.to_state
    assert_equal 2, wt.performed_actions.count
    action_names = []
    wt.performed_actions.each { |a| action_names << a['action_name'] }
    assert action_names.include?('reminder_to_organization')
    assert action_names.include?('apply_tag_in_database_success')
  end

  test "Workflow.send_event should raise an error if transition is not between possible transitions for current state" do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
    wf.access_request = access_requests(:one)
    wf.save!
    assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state
    exception = assert_raises(Exception) { wf.send_event(transitions(:data_came_back_transition)) }
    assert_equal( I18n.t('errors.transition_does_not_exist_in_current_state'), exception.message )
  end

  test "Workflow.send_event should not go to next state if a guard fails." do
    wf = Workflow.new
    wf.access_request = access_requests(:one)
    wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
    wf.save!
    assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state

    g = guards(:simple_false_if)
    t = transitions(:access_request_created)
    t.guards << g
    t.save!

    wt = wf.send_event(t)
    assert_equal 'guard_failed', wt.status
    assert_equal  g.id, wt.failed_guard_id
    assert_nil wt.performed_actions
  end

  test "workflow.send_event should rollback all the performed_actions if an action fails" do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
    wf.access_request = access_requests(:one)
    wf.save!
    assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state

    t = transitions(:access_request_created)
    a_with_failure = code_actions(:apply_tag_in_database) # action with failure
    action_without_rollback = code_actions(:test_success_action_without_rollback)
    t.actions << action_without_rollback
    t.actions << a_with_failure
    t.save!

    wt = wf.send_event(t)
    assert_equal 'action_failed', wt.status
    assert_equal a_with_failure.id, wt.failed_action_id, wt.inspect
    assert wt.rollback_failed_actions, wt.inspect
    assert_equal 1, wt.rollback_failed_actions.count, wt.inspect
    assert_equal action_without_rollback.id, wt.rollback_failed_actions.first['action_id'], wt.inspect
  end
end
