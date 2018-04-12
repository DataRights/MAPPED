require 'test_helper'

class DynamicControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should get authorized_content" do
    sign_in users(:one)
    get '/content/faq'
    assert_response :success
  end

  test "authorized content without sign in should get redirected to login" do
    get '/content/faq'
    assert_redirected_to new_user_session_url
  end

  test "should get anonymous_content" do
    get '/content/public/faq'
    assert_response :success
  end

end
