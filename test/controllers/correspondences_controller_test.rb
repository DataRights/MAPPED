require 'test_helper'

class CorrespondencesControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should get download" do
    sign_in users(:one)
    get download_correspondence_url(correspondences(:one))
    assert_response :success
  end

end
