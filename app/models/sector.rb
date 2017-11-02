class Sector < ApplicationRecord
  has_many :organizations
  has_and_belongs_to_many :templates

  def context_value
    {'name' => name}
  end
end
