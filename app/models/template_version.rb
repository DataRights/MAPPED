# == Schema Information
#
# Table name: template_versions
#
#  id          :integer          not null, primary key
#  version     :string
#  template_id :integer
#  content     :text
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TemplateVersion < ApplicationRecord
  belongs_to :template

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
