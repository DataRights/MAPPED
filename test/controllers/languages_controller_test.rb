require 'test_helper'

class LanguagesControllerTest < ActionDispatch::IntegrationTest
  test "should get set" do
    get languages_set_url
    assert_response :success
  end

end
