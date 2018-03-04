# == Schema Information
#
# Table name: workflows
#
#  id                       :integer          not null, primary key
#  workflow_type_version_id :integer
#  workflow_state_id        :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  access_request_id        :integer
#

class Workflow < ApplicationRecord
  belongs_to :workflow_type_version
  belongs_to :workflow_state
  belongs_to :access_request
  has_many :workflow_transitions, dependent: :destroy
  validates :workflow_type_version, :workflow_state, :access_request, presence: true
  validate :workflow_type_should_be_active
  after_create :set_transition_timeout
  before_validation(on: :create) do
   self.workflow_state = WorkflowState.where(workflow_type_version: self.workflow_type_version, is_initial_state: true).first
  end

  include ActionView::Helpers::DateHelper

  def workflow_type_should_be_active
    unless self.workflow_type_version && self.workflow_type_version.active
      errors.add(:workflow_type_version, I18n.t('validations.workflow_type_should_be_active'))
    end
  end

  def context_value
    { 'workflow_state' => self.workflow_state.name, 'created_at' => self.created_at, 'updated_at' => self.updated_at }
  end

  def send_event_with_transition_id(transition_id)
    send_event(Transition.find(transition_id))
  end

  def send_event(transition, event_id=nil, remarks=nil)
    unless self.workflow_state.possible_transitions.include?(transition)
      raise I18n.t('errors.transition_does_not_exist_in_current_state')
    end

    wt = WorkflowTransition.new
    wt.transition = transition
    wt.workflow = self
    (wt.event_id = event_id) if event_id
    wt.remarks = remarks
    wt.execute
    wt.save
    self.save
    wt
  end

  def set_transition_timeout
    self.workflow_state.possible_transitions.each do |t|
      unless t.timeout_days.nil?
        TransitionTimeoutJob.set(wait: t.timeout_days.days).perform_later(self.id, self.workflow_state.id, t.id)
        break
      end
    end
  end

  def has_timout_transition?
    workflow_state.possible_transitions.where.not(timeout_days: nil).first
  end

  def timeout_distance
    if has_timout_transition?
      t = workflow_state.possible_transitions.where.not(timeout_days: nil).first
      timeout = updated_at + t.timeout_days.days
      distance = distance_of_time_in_words timeout, Time.now
      left = I18n.t('access_requests.templates.awaiting_response.left')
      passed = I18n.t('access_requests.templates.awaiting_response.passed')
      Time.now > timeout ? "(#{distance} #{passed})" : "(#{distance} #{left})"
    end
  end
end
