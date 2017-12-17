# == Schema Information
#
# Table name: workflow_state_forms
#
#  id         :integer          not null, primary key
#  name       :string
#  form_path  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkflowStateForm < ApplicationRecord
  has_many :workflow_states
  validates :name, :form_path, presence: true
end
