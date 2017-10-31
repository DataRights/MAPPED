# == Schema Information
#
# Table name: workflow_states
#
#  id                       :integer          not null, primary key
#  name                     :string
#  workflow_type_version_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class WorkflowState < ApplicationRecord
  belongs_to :workflow_type_version
  has_many :possible_transitions, class_name: "Transition", foreign_key: "from_state_id"
  validates :name, :workflow_type_version, presence: true
  validate :workflow_type_not_active

  def workflow_type_not_active
    if self.workflow_type_version.active
      errors.add(:workflow_type_version, I18n.t('validations.workflow_type_is_active'))
    end
  end
end
