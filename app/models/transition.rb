# == Schema Information
#
# Table name: transitions
#
#  id            :integer          not null, primary key
#  name          :string
#  from_state_id :integer
#  to_state_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Transition < ApplicationRecord
  belongs_to :from_state, class_name: 'WorkflowState'
  belongs_to :to_state, class_name: 'WorkflowState'
  validates :from_state, :to_state, :name, presence: true
  validates :to_state, uniqueness: { scope: :from_state }
  has_and_belongs_to_many :actions
  has_and_belongs_to_many :guards

  # should return state, success:false/true, message (in case of error, error_message)
  def execute(workflow)
    guards.each do |g|
      guard_result = g.check(workflow)
      unless guard_result[:result]
        return { success: false, message: guard_result[:message], state: self.from_state }
      end
    end

    # TODO: add rollback
    actions.each do |a|
      action_result = a.execute(workflow)
      unless action_result[:result]
        return { success: false, message: action_result[:message], state: self.from_state }
      end
    end

    { success: true, message: 'all guards passed and actions executed successfully!', state: self.to_state }
  end
end
