require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get find" do
    get "/events/#{events(:one).id}"
    assert_response :success
  end

end
