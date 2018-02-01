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
  has_many :template_versions, dependent: :destroy
  has_and_belongs_to_many :sectors
  has_many :tags, :as => :tagable, dependent: :destroy
  has_many :comments, :as => :commentable, dependent: :destroy
  validates_presence_of :name, :template_type

  enum template_type:  [:access_request, :reminder, :followup, :custom, :notification, :terms_of_service, :faq, :'second reminder']
end
