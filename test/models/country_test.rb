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

  test "Must have languages" do
      country = Country.new(name: 'UK')
      assert_not country.valid?
      country.languages = ['en']
      assert country.valid?
  end
end
