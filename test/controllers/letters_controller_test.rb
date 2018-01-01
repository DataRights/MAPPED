require 'test_helper'

class LettersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should get download" do
    sign_in users(:one)
    get download_letter_url(letters(:one))
    assert_response :success
  end

end
