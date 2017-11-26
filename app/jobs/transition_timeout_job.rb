class TransitionTimeoutJob < ApplicationJob
  queue_as :default

  def perform(*args)
    workflow_id = args[0]
    workflow_state_id = args[1]
    transition_id = args[2]

    wf = Workflow.find workflow_id
    state = WorkflowState.find workflow_state_id
    transition = Transition.find transition_id

    return unless wf and state and transition
    return unless wf.workflow_state = state
    return unless wf.workflow_state.possible_transitions.include?(transition)

    wf.send_event(transition)
  end
end
