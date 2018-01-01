require 'test_helper'

class LettersControllerTest < ActionDispatch::IntegrationTest
  test "should get download" do
    get letters_download_url
    assert_response :success
  end

end
