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
  before_destroy :update_related_caches
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
    Rails.cache.delete("campaign/#{self.campaign_id}/count_of_access_requests") if campaign
    Rails.cache.delete("user/#{self.user_id}/campaign/#{self.campaign_id}/count_of_access_requests") if campaign
  end

  def create_workflow
    wf = Workflow.new
    wf.workflow_type_version = self.campaign.workflow_type.current_version
    wf.access_request = self
    wf.save!
  end

  def get_rendered_template(template_type)
    @rendered_template ||= AccessRequest.get_rendered_template(template_type, self.user, self.campaign, self.organization)
  end

  def self.get_rendered_template(template_type, user, campaign, organization)
    expected_langs = organization.languages
    accepted_versions = []
    active_templates = organization.sector.templates.joins(:template_versions).where(:templates => {template_type: template_type}, :template_versions => {:active => true})
    active_templates.each do |template|
      template.template_versions.where(:active => true).each do |active_version|
        accepted_versions << active_version if expected_langs.include? active_version.language.to_sym
      end
    end
    return nil if accepted_versions.blank?
    prefered_lang = user.preferred_language
    prefered_lang ||= :en
    result = accepted_versions.detect {|active_version| active_version.language == prefered_lang}
    result ||= accepted_versions.first

    if result
      context = TemplateContext.new
      context.campaign = campaign
      context.user = user
      context.organization = organization
      result.render(context)
    else
      nil
    end
  end
end
