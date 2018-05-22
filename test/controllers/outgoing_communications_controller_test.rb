require 'test_helper'

class OutgoingCommunicationsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should get download" do
    sign_in users(:one)
    get download_outgoing_communication_url(outgoing_communications(:one))
    assert_response :success
  end

end
