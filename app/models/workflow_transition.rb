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
#  rollback_failed_actions :string
#  performed_actions       :string
#  internal_data           :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class WorkflowTransition < ApplicationRecord
  belongs_to :workflow
  belongs_to :transition
  belongs_to :failed_action
  belongs_to :failed_guard

  attr_accessor :actions_executed

  # should return state, success:false/true, message (in case of error, error_message)
  def execute
    begin
      return false unless check_guards
      self.execute_actions
      self.rollback_actions unless self.failed_action.nil?
      return self.failed_action.nil?
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
    self.actions_executed = []
    self.transition.actions.each do |a|
      action_result = a.execute(self.workflow)
      if action_result
        actions_executed << a
      else
        self.failed_action = a
        self.action_failed_message = action_result[:message]
      end
    end
    self.performed_actions = actions_executed.join(',')
  end

  def rollback_actions
    self.status = :action_failed
    a_rollback_failed_actions = []
    self.actions_executed.each do |a|
      if a.methods.include?(:rollback)
        unless a.rollback(self.workflow)
          a_rollback_failed_actions << a
        end
      end
    end

    self.rollback_failed_actions = a_rollback_failed_actions.join(',')
  end

end
