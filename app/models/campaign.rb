# == Schema Information
#
# Table name: campaigns
#
#  id                   :integer          not null, primary key
#  name                 :string
#  short_description    :string
#  expanded_description :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Campaign < ApplicationRecord
  has_and_belongs_to_many :organizations
  has_many :access_requests
  has_and_belongs_to_many :questions
  has_many :answers, as: :answerable
  has_and_belongs_to_many :users
  after_create :invalidate_top_three
  after_destroy :invalidate_top_three

  def context_value
    result = { 'name' => name.blank? ? '' : name }
    result['short_description']  = short_description if short_description
    result['expanded_description'] = expanded_description if expanded_description
    result
  end

  def self.top_three
    Rails.cache.fetch("campaigns/top_three", expires_in: 120.minutes) do
      Campaign.last(3)
    end
  end

  def invalidate_top_three
    Rails.cache.delete("campaigns/top_three")
  end
end
