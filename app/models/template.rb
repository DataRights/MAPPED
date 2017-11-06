# == Schema Information
#
# Table name: templates
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  template_type :integer
#

class Template < ApplicationRecord
  has_many :template_versions
  has_and_belongs_to_many :sectors
  enum template_type:  [:access_request, :reminder, :followup, :custom]
end
