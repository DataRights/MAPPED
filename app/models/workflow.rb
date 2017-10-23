class Workflow < ApplicationRecord
  belongs_to :workflow_type_version
  belongs_to :workflow_state
end
