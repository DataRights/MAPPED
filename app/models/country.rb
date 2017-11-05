class Country < ApplicationRecord
  has_many :cities

  def context_value
    {'name' => name}
  end
end
