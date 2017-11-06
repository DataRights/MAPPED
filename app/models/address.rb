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

class Address < ApplicationRecord
  belongs_to :city
  belongs_to :country
  belongs_to :addressable, polymorphic: true

  def context_value
    result = {
      'line1' => line1.blank? ? '' : line1,
      'line2' => line2.blank? ? '' : line2,
      'post_code' => post_code.blank? ? '' : post_code,
    }
    result['city'] = city.context_value if city
    result['country'] = country.context_value if country
    result
  end

end
