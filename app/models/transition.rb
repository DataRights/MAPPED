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

end
