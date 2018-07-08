# == Schema Information
#
# Table name: access_requests
#
#  id                  :integer          not null, primary key
#  organization_id     :integer
#  user_id             :integer
#  meta_data           :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  campaign_id         :integer
#  private_attachments :boolean          default(FALSE)
#  uid                 :uuid             not null
#

class AccessRequest < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :campaign
  has_one :workflow, dependent: :destroy
  has_many :answers, as: :answerable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :correspondences, dependent: :destroy
  before_save :update_related_caches, if: :campaign_id_changed?
  before_save :update_correspondence, unless: :new_record?
  before_destroy :update_related_caches
  after_create :create_workflow

  attr_accessor :sector_id
  attr_accessor :template_id
  attr_accessor :ar_method
  attr_accessor :uploaded_access_request_file
  attr_accessor :final_text
  attr_accessor :suggested_text
  attr_accessor :attachment_id

  validates :user, :organization, :campaign, presence: true
  validate :final_text_present
  validate :pdf_file_present

  def final_text_present
    errors.add(:final_text, I18n.t('validations.final_text_empty')) if ar_method == 'template' && final_text.empty?
  end

  def pdf_file_present
    errors.add(:pdf_file_present, I18n.t('validations.pdf_file_present')) if ar_method == 'uplaod' && uploaded_access_request_file.nil?
  end

  def title
    "#{organization.name} - #{user.email}"
  end

  def context_value
    { 'id' => id }
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
    t = wf.workflow_state.possible_transitions.where(is_initial_transition: true).first
    return true unless t
    ar_step = wf.send_event(t)
    ActiveRecord::Base.transaction do
      c = Correspondence.new
      c.direction = :outgoing
      c.correspondence_type = :access_request
      c.final_text = final_text
      c.access_request_step_id = ar_step.id
      c.access_request = self
      if uploaded_access_request_file and attachment_id
        a = Attachment.find(attachment_id)
        a.attachable = c
        a.save!
      end
      c.save!
    end
  end

  def update_correspondence
    c = correspondences.find_by(correspondence_type: :access_request)
    return true unless c
    c.final_text = final_text
    if uploaded_access_request_file and attachment_id
      a = Attachment.find(attachment_id)
      a.attachable = c
      a.save!
    end
    c.save!
  end

  def has_file?
    c = correspondences.find_by(correspondence_type: :access_request)
    return false unless c
    c.attachments.count > 0
  end

  def ar_attachment
    c = correspondences.find_by(correspondence_type: :access_request)
    return nil unless c
    c.attachments.first
  end

  def ar_text
    c = correspondences.find_by(correspondence_type: :access_request)
    c&.final_text
  end

  def access_request_file
    c = correspondences.find_by(correspondence_type: :access_request)
    c&.attachments&.first&.content
  end

  def access_request_file_content_type
    c = correspondences.find_by(correspondence_type: :access_request)
    c&.attachments&.first&.content_type
  end

  def self.available_templates(template_type, organization)
    return [] unless organization.sector
    if template_type.class == :String
      template_type = template_type.to_sym
    end
    return [] unless Template.template_types.include?(template_type)
    active_templates = organization.sector.templates.where(:template_type => template_type, :active => true)
    return [] if active_templates.blank?
    active_templates
  end

  def get_rendered_template(template_type, template=nil)
    @rendered_template ||= AccessRequest.get_rendered_template(template_type, self.user, self.campaign, self.organization, self, template)
  end

  def self.get_rendered_template(template_type, user, campaign, organization, access_request=nil, template=nil)
    return nil unless organization.sector

    if template_type.class == :String
      template_type = template_type.to_sym
    end

    unless Template.template_types.include?(template_type)
      return ''
    end

    active_templates = organization.sector.templates.where(:template_type => template_type, :active => true)
    return nil if active_templates.blank?

    result = nil
    if template
      result = active_templates.detect {|t| t.id == template.id}
    else
      result = active_templates.first
    end

    if result
      context = TemplateContext.new
      if access_request && access_request&.workflow
        context.access_request = access_request
        context.workflow = access_request.workflow
      end
      context.campaign = campaign
      context.user = user
      context.organization = organization
      result.render(context)
    else
      nil
    end
  end
end
