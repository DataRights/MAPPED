# == Schema Information
#
# Table name: workflow_type_versions
#
#  id               :integer          not null, primary key
#  version          :float
#  workflow_type_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  active           :boolean          default(FALSE)
#

class WorkflowTypeVersion < ApplicationRecord
  belongs_to :workflow_type
  validates :version, :workflow_type, presence: true
  validates :version, uniqueness: { scope: :workflow_type }
  validate :presence_of_initial_state
  after_save :make_other_versions_inactive

  def make_other_versions_inactive
    return unless self.active
    other_versions = WorkflowTypeVersion.where(active: true, workflow_type_id: self.workflow_type.id).where.not(id: self.id)
    other_versions.each do |o|
      o.active = false
      o.save!
    end
  end

  def presence_of_initial_state
    if self.active
      initial_state = WorkflowState.where(workflow_type_version: self, is_initial_state: true).first
      unless initial_state
        errors.add(:active, I18n.t('validations.initial_state_is_mandatory'))
      end
    end
  end
end
