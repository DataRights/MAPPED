# == Schema Information
#
# Table name: access_requests
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  user_id            :integer
#  meta_data          :jsonb
#  sent_date          :datetime
#  data_received_date :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  campaign_id        :integer
#  suggested_text     :text
#  final_text         :text
#

class AccessRequest < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :campaign
  has_one :workflow, dependent: :destroy
  has_many :tags, :as => :tagable, dependent: :destroy
  has_many :comments, :as => :commentable, dependent: :destroy
  before_save :update_related_caches, if: :campaign_id_changed?
  after_create :create_workflow

  validates :user, :organization, :campaign, presence: true

  def context_value
    { 'id' => id, 'data_received_date' => self.data_received_date, 'sent_date' => self.sent_date }
  end

  def update_related_caches
    if self.changes.include?('campaign_id')
      old_campaign_id = self.changes['campaign_id'].first
      Rails.cache.delete("campaign/#{old_campaign_id}/count_of_access_requests") if old_campaign_id
    end
    Rails.cache.delete("campaign/#{self.campaign.id}/count_of_access_requests") if campaign
  end

  def create_workflow
    wf = Workflow.new
    wf.workflow_type_version = self.campaign.workflow_type.current_version
    wf.access_request = self
    wf.save!
  end
end
