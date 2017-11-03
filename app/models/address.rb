class Address < ApplicationRecord
  belongs_to :city
  belongs_to :country
  belongs_to :addressable, polymorphic: true
end
