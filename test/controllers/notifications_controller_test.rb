require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should get index with notifications" do
    sign_in users(:one)
    get notifications_index_url
    assert_response :success
    n1 = notifications(:one)
    n2 = notifications(:two)
    assert response.body.include?(n1.title)
    assert response.body.include?(n1.content)
    assert_not response.body.include?(n2.title)
    assert_not response.body.include?(n2.content)
  end

  test "If user has no notification index should work" do
    sign_in users(:three)
    get notifications_index_url
    assert_response :success
  end

end
