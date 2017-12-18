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
  belongs_to :addressable, polymorphic: true, :inverse_of => :address
  before_validation :create_city
  validates_presence_of :line1

  attr_accessor :city_name

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

  after_initialize do |address|
    if address.city
      address.city_name = address.city.name
    end
  end

  def create_city
    return if city_name.blank? or country_id.blank?
    c = City.find_by name: city_name.capitalize
    if c.nil?
      c = City.new
      c.country_id = self.country_id
      c.name = city_name.capitalize
      c.save!
    end
    self.city = c
  end

end
