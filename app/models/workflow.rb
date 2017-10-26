# == Schema Information
#
# Table name: workflows
#
#  id                       :integer          not null, primary key
#  workflow_type_version_id :integer
#  workflow_state_id        :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Workflow < ApplicationRecord
  belongs_to :workflow_type_version
  belongs_to :workflow_state
  validates :workflow_type_version, :workflow_state, presence: true
end
