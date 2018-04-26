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
#  email            :string
#  city_name        :string
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'line1' => 'somewhere', 'line2' => 'somewhere else', 'post_code' => 'NW12'}), Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12').context_value
    assert_equal ({'line1' => 'somewhere', 'line2' => 'somewhere else', 'post_code' => 'NW12', 'city' => {'name' => 'London'}}), Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', city: City.new(name: 'London')).context_value
    assert_equal ({'line1' => 'somewhere', 'line2' => 'somewhere else', 'post_code' => 'NW12', 'country' => {'name' => 'UK'}}), Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', country: Country.new(name: 'UK')).context_value
  end

  test 'If city_name is not on database, address model should create it' do
    assert_equal 0, City.where(name: 'Lisbon').count
    u = users(:one)
    a = Address.new
    a.line1 = 'Line 1'
    a.line2 = 'Line 2'
    a.post_code = '0152'
    a.city_name = 'lisbon' # Should capitalize the city name automatically
    a.country = countries(:portugal)
    u.address = a
    assert u.save
    assert_equal 1, City.where(name: 'Lisbon').count
  end
end
