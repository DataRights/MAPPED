# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ApplicationRecord
  belongs_to :country
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :country_id

  def context_value
    {'name' => name}
  end
end
