class Campaign < ApplicationRecord
  has_and_belongs_to_many :organizations
  has_many :access_requests
  has_and_belongs_to_many :questions
end
