require 'test_helper'

class WorkflowControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "calling diagram with invalid params should return error messages" do
    sign_in users(:one)
    get "/workflow/diagram/s"
    assert_response :success
    assert @response.body.include?(I18n.t('invalid_parameters'))
  end
end
