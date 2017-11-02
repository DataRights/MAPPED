require 'test_helper'

class SectorTest < ActiveSupport::TestCase
   test "the context_value" do
     assert_equal ({'name' => 'health'}), Sector.new(name: 'health').context_value
   end
end
