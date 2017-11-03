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
