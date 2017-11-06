# == Schema Information
#
# Table name: workflows
#
#  id                       :integer          not null, primary key
#  workflow_type_version_id :integer
#  workflow_state_id        :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Workflow < ApplicationRecord
  belongs_to :workflow_type_version
  belongs_to :workflow_state
  belongs_to :access_request
  validates :workflow_type_version, :workflow_state, presence: true
  validate :workflow_type_should_be_active
  before_validation(on: :create) do
   self.workflow_state = WorkflowState.where(workflow_type_version: self.workflow_type_version, is_initial_state: true).first
  end

  def workflow_type_should_be_active
    unless self.workflow_type_version && self.workflow_type_version.active
      errors.add(:workflow_type_version, I18n.t('validations.workflow_type_should_be_active'))
    end
  end

  def send_event(transition)
    unless self.workflow_state.possible_transitions.include?(transition)
      raise I18n.t('errors.transition_does_not_exist_in_current_state')
    end

    wt = WorkflowTransition.new
    wt.transition = transition
    wt.workflow = self
    wt.execute
    wt.save
    self.save
    wt
  end
end
