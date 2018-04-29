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

class Address < ApplicationRecord
  belongs_to :country
  belongs_to :addressable, polymorphic: true, :inverse_of => :address
  validates_presence_of :line1, :city_name
  before_save :capitalize_city_name!

  def context_value
    result = {
      'line1' => line1.blank? ? '' : line1,
      'line2' => line2.blank? ? '' : line2,
      'post_code' => post_code.blank? ? '' : post_code,
    }
    unless city_name.blank?
      result['city'] = city_name
    end
    result['country'] = country.context_value if country
    result
  end

  def capitalize_city_name!
    self.city_name&.capitalize!
  end

end
