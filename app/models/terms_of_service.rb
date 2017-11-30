# == Schema Information
#
# Table name: terms_of_services
#
#  id          :integer          not null, primary key
#  template_id :integer
#  title       :string           not null
#  type_of     :integer          not null
#  mandatory   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TermsOfService < ApplicationRecord
  belongs_to :template
  has_many :campaigns
  validates_presence_of :type_of, :title, :template_id
  enum type_of:  [:campaign, :share_with_researchers, :share_in_forum]
end
