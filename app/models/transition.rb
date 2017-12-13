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
#  timeout_days  :float
#

class Transition < ApplicationRecord
  belongs_to :from_state, class_name: 'WorkflowState'
  belongs_to :to_state, class_name: 'WorkflowState'
  has_and_belongs_to_many :actions, class_name: 'CodeAction'
  has_and_belongs_to_many :guards
  validates :from_state, :to_state, :name, presence: true
  validates :to_state, uniqueness: { scope: :from_state }
  validate :only_one_timeout_from_one_state

  def only_one_timeout_from_one_state
    return unless self.timeout_days
    other_transition_timeout = Transition.where(from_state_id: self.from_state_id).where.not(timeout_days: nil).where.not(id: self.id).first
    if other_transition_timeout
      errors.add(:timeout_days, I18n.t('workflow.state_has_already_one_timeout_transition', transition: other_transition_timeout.to_json))
    end
  end
end
