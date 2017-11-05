require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name' => 'hosp1'}), Organization.new(name: 'hosp1').context_value
    assert_equal ({'name' => 'hosp1', 'sector' => {'name' => 'health'}}), Organization.new(name: 'hosp1', sector: Sector.new(name: 'health')).context_value
    assert_equal ({'name' => 'hosp1', 'custom_1' => 'aaa' , 'custom_1_desc' => 'bbb' }), Organization.new(name: 'hosp1', custom_1: 'aaa', custom_1_desc: 'bbb').context_value
    assert_equal ({'name' => 'hosp1', 'custom_2' => 'aaa' , 'custom_2_desc' => 'bbb' }), Organization.new(name: 'hosp1', custom_2: 'aaa', custom_2_desc: 'bbb').context_value
    assert_equal ({'name' => 'hosp1', 'custom_3' => 'aaa' , 'custom_3_desc' => 'bbb' }), Organization.new(name: 'hosp1', custom_3: 'aaa', custom_3_desc: 'bbb').context_value
  end
end
