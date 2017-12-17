require 'test_helper'

class WorkflowControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index and display generated workflow when workflow has states" do
    sign_in users(:one)
    w = workflow_type_versions(:version_one_point_o_mapped_social)
    get "/workflow/diagram/#{w.id}"
    assert_response :success
    assert_nil flash[:notice]
  end

  test 'get index should return an error when specified workflow type version does not have any workflow_states' do
    sign_in users(:one)
    w  = workflow_type_versions(:workflow_without_states)
    get "/workflow/diagram/#{w.id}"
    assert_response :success
    assert_equal I18n.t('workflow.no_state_to_generate_diagram'), flash[:notice]
  end

end
