class Transition < ApplicationRecord
  belongs_to :from_state, :class_name => 'WorkflowState'
  belongs_to :to_state, :class_name => 'WorkflowState'
  validates :to_state, uniqueness: { scope: :from_state }
end
