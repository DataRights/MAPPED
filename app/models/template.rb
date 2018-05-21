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
  has_and_belongs_to_many :sectors
  #has_many :tags, :as => :tagable, dependent: :destroy
  #has_many :comments, :as => :commentable, dependent: :destroy
  validates_presence_of :name, :template_type
  validates_presence_of :version, :content, :language

  enum template_type:  [:access_request, :reminder, :followup, :custom, :notification, :terms_of_service, :faq, :'second reminder', :about]

  def self.dynamic_page_content(template_type, user=nil)
    #templates = Template.joins(:template_versions).where(template_type: template_type, :template_versions => {:active => true})
    templates = Template.where(:template_type => template_type, :active => true)
    #result = templates.first&.template_versions&.first
    result = templates.first
    templates.each do |tv|
      #t.template_versions.where(:active => true).each do |tv|
        if tv.language.try(:to_sym) == user&.preferred_language
          result = tv
          break
        end
      #end
    end

    if result
      context = TemplateContext.new
      context.user = user if user
      result.render(context)&.html_safe
    else
      nil
    end
  end

  def render(template_context)
    return '' if content.blank?
    raise 'Invalid context' unless template_context
    raise 'Wrong context type' unless template_context.is_a? TemplateContext
    @template = Liquid::Template.parse(content)
    @template.render(template_context.context_value)
  end

  def language
    self.attributes['language'].try(:to_sym)
  end

end
