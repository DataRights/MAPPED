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
  #HA has_many :tags, :as => :tagable, dependent: :destroy
  #has_many :comments, :as => :commentable, dependent: :destroy
  validates_presence_of :name, :template_type

  enum template_type:  [:access_request, :reminder, :followup, :custom, :notification, :terms_of_service, :faq, :'second reminder', :about]

  def self.dynamic_page_content(template_type, user=nil)
    templates = Template.joins(:template_versions).where(template_type: template_type, :template_versions => {:active => true})
    result = templates.first&.template_versions&.first
    templates.each do |t|
      t.template_versions.where(:active => true).each do |tv|
        if tv.language.try(:to_sym) == user&.preferred_language
          result = tv
          break
        end
      end
    end

    if result
      context = TemplateContext.new
      context.user = user if user
      result.render(context)&.html_safe
    else
      nil
    end
  end
end
