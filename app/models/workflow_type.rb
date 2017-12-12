# == Schema Information
#
# Table name: workflow_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkflowType < ApplicationRecord
  validates :name, presence: true

  def current_version
    WorkflowTypeVersion.find_by workflow_type_id: self.id, active: true
  end
end
