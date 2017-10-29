module ActionTestHelper

  def self.reminder_to_organization(workflow)
    { result: true, message: "reminder successfully sent to workflow in state: #{workflow.workflow_state.name}"}
  end

  def self.apply_tag_in_database(workflow)
    { result: false, message: "tag failed to apply to workflow in state: #{workflow.workflow_state.name}"}
  end
end
