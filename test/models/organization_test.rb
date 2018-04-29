# == Schema Information
#
# Table name: organizations
#
#  id                   :integer          not null, primary key
#  name                 :string
#  sector_id            :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  custom_1             :text
#  custom_1_desc        :text
#  custom_2             :text
#  custom_2_desc        :text
#  custom_3             :text
#  custom_3_desc        :text
#  languages            :string           default([]), is an Array
#  privacy_policy_url   :string
#  approved             :boolean          default(TRUE)
#  suggested_by_user_id :integer
#

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "the context_value" do
    assert_equal ({'name' => 'hosp1'}), Organization.new(name: 'hosp1').context_value
    assert_equal ({'name' => 'hosp1', 'sector' => {'name' => 'health'}}), Organization.new(name: 'hosp1', sector: Sector.new(name: 'health')).context_value
    assert_equal ({'name' => 'hosp1', 'custom_1' => 'aaa' , 'custom_1_desc' => 'bbb' }), Organization.new(name: 'hosp1', custom_1: 'aaa', custom_1_desc: 'bbb').context_value
    assert_equal ({'name' => 'hosp1', 'custom_2' => 'aaa' , 'custom_2_desc' => 'bbb' }), Organization.new(name: 'hosp1', custom_2: 'aaa', custom_2_desc: 'bbb').context_value
    assert_equal ({'name' => 'hosp1', 'custom_3' => 'aaa' , 'custom_3_desc' => 'bbb' }), Organization.new(name: 'hosp1', custom_3: 'aaa', custom_3_desc: 'bbb').context_value
  end

  test 'must have an address and language' do
    o = Organization.new(name: 'datarights', sector: Sector.new(name: 'IT'))
    assert_not o.valid?
    o.address = Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', city_name: 'London', country: Country.new(name: 'UK'), addressable: o)
    o.languages = [:en]
    assert o.valid?
  end

  test 'should return langugaes from address if there is no languages' do
    o = Organization.new(name: 'datarights', sector: Sector.new(name: 'IT'))
    country = Country.new(name: 'UK')
    country.languages = [:en,:ar]
    o.address = Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', city_name: 'London', country: country, addressable: o)
    assert_equal [:en,:ar], o.languages
  end

  test 'should return its own language instead of address languages (override)' do
    o = Organization.new(name: 'datarights', sector: Sector.new(name: 'IT'))
    o.languages = [:kq,:rw]
    country = Country.new(name: 'UK')
    country.languages = [:en,:ar]
    o.address = Address.new(line1: 'somewhere', line2: 'somewhere else', post_code: 'NW12', city_name: 'London', country: country, addressable: o)
    assert_equal [:kq,:rw], o.languages
  end
end
