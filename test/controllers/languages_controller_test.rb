require 'test_helper'

class LanguagesControllerTest < ActionDispatch::IntegrationTest
  test "should get set" do
    get languages_set_url(lang: :nl)
    assert_redirected_to controller: "home", action: "index"
  end

end
