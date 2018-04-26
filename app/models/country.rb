# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  languages  :string           default([]), is an Array
#  iso        :string
#

class Country < ApplicationRecord
  has_many :addresses, :dependent => :destroy
  #validates_presence_of :languages

  def context_value
    {'name' => name}
  end

  def languages
    result = self[:languages]
    result ||= []
    result.map {|language| language.to_sym}
  end
end
