require 'test_helper'

class ConsentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get consent_show_url(terms_of_services(:one).id)
    assert_response :success
  end

end
