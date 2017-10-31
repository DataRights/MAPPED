# == Schema Information
#
# Table name: workflow_types
#
#  id             :integer          not null, primary key
#  name           :string
#  active_version :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class WorkflowType < ApplicationRecord
  validates :name, presence: true
end
