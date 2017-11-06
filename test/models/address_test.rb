# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  line1            :string
#  line2            :string
#  post_code        :string
#  city_id          :integer
#  country_id       :integer
#  addressable_type :string
#  addressable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'line1' => 'somewhere', 'line2' => 'somewhere else', 'post_code' => 'NW12'}), Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12').context_value
    assert_equal ({'line1' => 'somewhere', 'line2' => 'somewhere else', 'post_code' => 'NW12', 'city' => {'name' => 'London'}}), Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', city: City.new(name: 'London')).context_value
    assert_equal ({'line1' => 'somewhere', 'line2' => 'somewhere else', 'post_code' => 'NW12', 'country' => {'name' => 'UK'}}), Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', country: Country.new(name: 'UK')).context_value
  end
end
