# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name' => 'UK'}), Country.new(name: 'UK').context_value
  end
end
