module GuardTestHelper
  def self.check_answer_to_life(workflow)
    { result: 42 == 42, message: 'success!' }.with_indifferent_access

  end

  def self.check_two_plus_two_equals_five(workflow)
    { result: 2 + 2 == 5, message: '2 + 2 does not equals 5!'}.with_indifferent_access
  end

  def self.check_something_in_workflow(workflow)
    { result: workflow.workflow_state.name == 'Initial State', message: "workflow state is: #{workflow.workflow_state.name}"}
  end
end
