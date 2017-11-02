class Sector < ApplicationRecord
  has_many :organizations

  def context_value
    {'name' => name}
  end
end
