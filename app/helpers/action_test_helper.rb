module ActionTestHelper

  def self.reminder_to_organization(workflow)
    { result: true, message: "reminder successfully sent to workflow in state: #{workflow.workflow_state.name}"}
  end

  def self.reminder_to_organization_rollback(workflow)
    { result: true, message: "reminder successfully rollbacked!"}
  end

  def self.test_success_action_without_rollback(workflow)
    { result: true, message: "action successfully executed!"}
  end

  def self.apply_tag_in_database_success(workflow)
    { result: true, message: "tag succeessflly applied to workflow in state: #{workflow.workflow_state.name}"}
  end

  def self.apply_tag_in_database(workflow)
    { result: false, message: "tag failed to apply to workflow in state: #{workflow.workflow_state.name}"}
  end

  def self.another_sample_action(workflow)
    { result: true, message: 'Success!' }
  end
end
