require 'test_helper'

class CityTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name' => 'London'}), City.new(name: 'London').context_value
  end
end
