class Template < ApplicationRecord
  has_many :template_versions
  has_and_belongs_to_many :sectors
  enum template_type:  [:access_request, :reminder, :followup, :custom]
end
