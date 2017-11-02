class TemplateVersion < ApplicationRecord
  belongs_to :template

  def render(template_context)
    return '' if content.blank?
    raise 'Invalid context' unless template_context
    raise 'Wrong context type' unless template_context.is_a? TemplateContext

    @template = Liquid::Template.parse(content)
    @template.render(template_context.context_value)
  end
end
