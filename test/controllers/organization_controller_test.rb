require 'test_helper'

class OrganizationControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should be able to create a new organization" do
    sign_in users(:one)
    post organizations_url, as: :js
    assert_response :success
  end

end
