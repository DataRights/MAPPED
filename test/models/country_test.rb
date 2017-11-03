require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name' => 'UK'}), Country.new(name: 'UK').context_value
  end
end
