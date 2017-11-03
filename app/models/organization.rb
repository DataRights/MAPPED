class Organization < ApplicationRecord
  belongs_to :sector
  has_many :addresses, as: :addressable

  def context_value
    result = { 'name' => name }
    result['sector'] = sector.context_value if sector
    result['custom_1'] = custom_1 if custom_1
    result['custom_1_desc'] = custom_1_desc if custom_1_desc
    result['custom_2'] = custom_2 if custom_2
    result['custom_2_desc'] = custom_2_desc if custom_2_desc
    result['custom_3'] = custom_3 if custom_3
    result['custom_3_desc'] = custom_3_desc if custom_3_desc
    result
  end

end
