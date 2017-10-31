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
#  internal_data           :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  performed_actions       :jsonb
#  rollback_failed_actions :jsonb
#

class WorkflowTransition < ApplicationRecord
  belongs_to :workflow
  belongs_to :transition
  belongs_to :failed_action
  belongs_to :failed_guard

  # should return state, success:false/true, message (in case of error, error_message)
  def execute
    begin
      return false unless check_guards
      self.execute_actions
      self.rollback_actions unless self.failed_action.nil?
      self.failed_action.nil?
    ensure
      self.save!
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
      if action_result
        self.performed_actions << a.id
      else
        self.failed_action = a
        self.action_failed_message = action_result[:message]
        break
      end
    end
    self.status = :success if self.failed_action.nil?
  end

  def rollback_actions
    self.status = :action_failed
    self.rollback_failed_actions = []
    self.performed_actions.each do |a|
      unless a.methods.include?(:rollback) && (rollback_result = a.rollback(self.workflow))
        self.rollback_failed_actions << {action_id: a.id, error_message: rollback_result[:message]}
      end
    end
  end

end
