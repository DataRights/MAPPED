# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CityTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name' => 'London'}), City.new(name: 'London').context_value
  end
end
