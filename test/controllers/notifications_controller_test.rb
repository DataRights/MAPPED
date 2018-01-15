require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get notifications_index_url
    assert_response :success
    n1 = notifications(:one)
    n2 = notifications(:two)
    assert response.body.include?(n1.title)
    assert response.body.include?(n1.content)
    assert_not response.body.include?(n2.title)
    assert_not response.body.include?(n2.content)
  end

end
