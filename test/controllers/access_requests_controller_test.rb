require 'test_helper'

class AccessRequestsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'should get index by campaign work' do
    sign_in users(:one)
    get campaign_access_requests_url(campaigns(:one).id)
    assert_response :success
  end
end
