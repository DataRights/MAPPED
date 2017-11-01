class Organization < ApplicationRecord
  belongs_to :sector
  has_and_belongs_to_many :templates
end
