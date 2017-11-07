class Campaign < ApplicationRecord
  has_and_belongs_to_many :organizations
  has_many :access_requests
  has_and_belongs_to_many :questions
  has_many :answers, as: :answerable

  def context_value
    result = { 'name' => name.blank? ? '' : name }
    result['short_description']  = short_description if short_description
    result['expanded_description'] = expanded_description if expanded_description
    result
  end

end
