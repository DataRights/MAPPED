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
  after_save :make_other_versions_inactive

  def make_other_versions_inactive
    return unless self.active
    other_versions = WorkflowTypeVersion.where(active: true, workflow_type_id: self.workflow_type.id).where.not(id: self.id)
    other_versions.each do |o|
      o.active = false
      o.save!
    end
  end
end
