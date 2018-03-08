# == Schema Information
#
# Table name: workflow_transitions
#
#  id                      :integer          not null, primary key
#  workflow_id             :integer
#  transition_id           :integer
#  failed_action_id        :integer
#  failed_guard_id         :integer
#  action_failed_message   :string
#  failed_guard_message    :string
#  status                  :string
#  rollback_failed_actions :jsonb
#  performed_actions       :jsonb
#  internal_data           :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  remarks                 :string
#  event_id                :integer
#

class WorkflowTransition < ApplicationRecord
  belongs_to :workflow
  belongs_to :transition
  belongs_to :failed_action, class_name: 'CodeAction', optional: true
  belongs_to :failed_guard, class_name: 'Guard', optional: true
  belongs_to :event, optional: true
  has_many   :attachments, dependent: :destroy
  has_many   :letters, dependent: :destroy

  # should return state, success:false/true, message (in case of error, error_message)
  def execute
    begin
      return false unless check_guards
      execute_actions
      rollback_actions unless self.failed_action.nil?
      self.failed_action.nil?
    ensure
      self.save!
    end
  end

  def undo
    if is_undoable
      t = get_or_create_undo_transition
      self.workflow.send_event(t)
      {:success => true, :message => I18n.t('workflow.undo_transition_was_successfull')}
    else
      {:success => false, :message => I18n.t('workflow.transition_is_not_undoable')}
    end
  end

  private

  def check_guards
    self.transition.guards.each do |g|
      guard_result = g.check(workflow)
      unless guard_result[:result]
        self.status = :guard_failed
        self.failed_guard = g
        self.failed_guard_message = guard_result[:message]
        return false
      end
    end

    true
  end

  def execute_actions
    self.performed_actions = []
    self.transition.actions.each do |a|
      action_result = a.execute(self.workflow)
      if action_result[:result]
        self.performed_actions << { action_id: a.id, action_name: a.name }
      else
        self.failed_action = a
        self.action_failed_message = action_result[:message]
        break
      end
    end
    if self.failed_action.nil?
      self.status = :success
      self.workflow.workflow_state = self.transition.to_state
      self.workflow.set_transition_timeout
    end
  end

  def rollback_actions
    self.status = :action_failed
    self.rollback_failed_actions = []
    self.performed_actions.each do |a|
      action = self.transition.actions.find_by id: a[:action_id]
      rollback_result = action.rollback(self.workflow)
      unless rollback_result[:result]
        self.rollback_failed_actions << {action_id: action.id, error_message: rollback_result[:message]}
      end
    end
  end

  def get_or_create_undo_transition
    t = Transition.where(from_state_id: self.transition.to_state_id, to_state_id: self.transition.from_state_id).first
    unless t
      t = Transition.new
      t.from_state_id = self.transition.to_state_id
      t.to_state_id = self.transition.from_state_id
      t.name = I18n.t('workflow.undo')
      t.history_description = I18n.t('workflow.undo_history', state: t.to_state.name)
      t.save!
    end
    t
  end

  def is_undoable
    self.workflow.workflow_transitions.order('created_at DESC').first.id == self.id
  end
end
