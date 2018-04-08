# == Schema Information
#
# Table name: workflow_states
#
#  id                       :integer          not null, primary key
#  name                     :string
#  workflow_type_version_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  is_initial_state         :boolean          default(FALSE)
#  workflow_state_form_id   :integer
#  button_text              :string
#  button_css_class         :string           default("btn")
#  button_style             :string
#

class WorkflowState < ApplicationRecord
  belongs_to :workflow_type_version
  belongs_to :workflow_state_form, optional: true
  has_many :possible_transitions, -> { order(:display_order) }, class_name: "Transition", foreign_key: "from_state_id", dependent: :destroy
  has_many :destination_transitions, class_name: "Transition", foreign_key: "to_state_id", dependent: :destroy
  validates :name, :workflow_type_version, presence: true
  validate :workflow_type_not_active

  def workflow_type_not_active

    return unless self.changes.include?(:workflow_type_version) or self.changes.include?(:is_initial_state)

    if self.workflow_type_version.active
      errors.add(:workflow_type_version, I18n.t('validations.workflow_type_is_active'))
    end
  end
end
