class FaqController < ApplicationController

  before_action :authenticate_user!

  def index
    templates = Template.joins(:template_versions).where(template_type: :faq, :template_versions => {:active => true})
    result = templates.first&.template_versions&.first
    templates.each do |t|
      t.template_versions.where(:active => true).each do |tv|
        if tv.language.try(:to_sym) == current_user.preferred_language
          result = tv
          break
        end
      end
    end

    if result
      context = TemplateContext.new
      context.user = current_user
      @rendered_template = result.render(context)&.html_safe
    else
      @rendered_template = ''
    end
  end
end
