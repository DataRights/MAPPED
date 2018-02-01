require 'test_helper'

class AccessRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should get index by campaign' do
    sign_in users(:one)
    get campaign_access_requests_url(campaigns(:one).id)
    assert_response :success
  end

  test "should get new" do
    skip 'need more complicated init values'
    get access_requests_new_url
    assert_response :success
  end

  test "should get create" do
    skip 'need more complicated init values'
    get access_requests_create_url
    assert_response :success
  end

  test 'should get a template type by access request' do
    sign_in users(:three)
    ar = access_requests(:three)
    get access_request_template_url(id: ar, template_type: :'second reminder')
    assert_response :success, response.body
    result = JSON.parse(response.body)
    expected_template = "The access request to #{ar.id} has been created on DataRights.me and it's ready for sending to organization #{ar.organization.name}. Currently status of your workflow is: #{ar.workflow.workflow_state.name}"
    assert_equal expected_template, result['template']
  end
end
