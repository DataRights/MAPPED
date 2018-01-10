require 'test_helper'

class WorkflowTransitionControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get workflow_transition_update_url
    assert_response :success
  end

end
