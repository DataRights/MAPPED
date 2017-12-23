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
#  policy_consent_id    :integer
#  workflow_type_id     :integer
#

class Campaign < ApplicationRecord
  has_and_belongs_to_many :organizations, dependent: :destroy
  has_many :access_requests, dependent: :destroy
  has_and_belongs_to_many :questions, dependent: :destroy
  has_many :answers, as: :answerable, dependent: :destroy
  has_and_belongs_to_many :users, dependent: :destroy
  belongs_to :policy_consent, optional: true
  belongs_to :workflow_type

  after_create :invalidate_top_three
  after_destroy :invalidate_top_three

  validates_presence_of :name, :workflow_type
  validate :presence_of_active_workflow_type
  CAMPAIGN_TOP_THREE_CACHE_NAME = 'campaigns/top_three'
  DEFAULT_CAMPAIGN_NAME = 'Default'

  def context_value
    result = { 'name' => name.blank? ? '' : name }
    result['short_description'] = short_description if short_description
    result['expanded_description'] = expanded_description if expanded_description
    result
  end

  def count_of_access_requests
    Rails.cache.fetch("campaign/#{self.id}/count_of_access_requests", expires_in: 120.minutes) do
      self.access_requests.count
    end
  end

  def count_of_access_requests_by_user(user)
    Rails.cache.fetch("user/#{user.id}/campaign/#{self.id}/count_of_access_requests", expires_in: 120.minutes) do
      self.access_requests.where(user_id: user.id).count
    end
  end

  def self.top_three
    Rails.cache.fetch(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME, expires_in: 120.minutes) do
      Campaign.last(3)
    end
  end

  def invalidate_top_three
    Rails.cache.delete(Campaign::CAMPAIGN_TOP_THREE_CACHE_NAME)
  end

  def presence_of_active_workflow_type
    return unless self.workflow_type
    unless self.workflow_type.current_version
      self.errors.add(:workflow_type, ' : There is no active workflow type version for selected workflow type.')
    end
  end
end
