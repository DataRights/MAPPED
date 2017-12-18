# == Schema Information
#
# Table name: sectors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sector < ApplicationRecord
  has_many :organizations, dependent: :destroy
  has_and_belongs_to_many :templates

  def context_value
    {'name' => name}
  end
end
