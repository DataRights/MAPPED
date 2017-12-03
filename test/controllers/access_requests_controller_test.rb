require 'test_helper'

class AccessRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:test_user)
    @user.confirm
    sign_in @user
    Campaign.create(:name => Campaign::DEFAULT_CAMPAIGN_NAME) unless Campaign.find_by(:name => Campaign::DEFAULT_CAMPAIGN_NAME)
  end

  test "should get index" do
    get access_requests_index_url
    assert_response :success
  end

  test "should get new" do
    get access_requests_new_url
    assert_response :success


  end

  test "should get create" do
    get access_requests_create_url
    assert_response :success
  end

end
