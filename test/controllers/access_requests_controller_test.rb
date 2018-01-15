require 'test_helper'

class AccessRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:three)
    @user.confirm
    sign_in @user
    Campaign.create(:name => Campaign::DEFAULT_CAMPAIGN_NAME) unless Campaign.find_by(:name => Campaign::DEFAULT_CAMPAIGN_NAME)
  end

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
end
