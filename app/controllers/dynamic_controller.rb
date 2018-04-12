class DynamicController < ApplicationController

  before_action :authenticate_user!, only: [:authorized_content]

  def authorized_content
    @rendered_template = Template.dynamic_page_content params[:template_type].to_sym, current_user
    render :content
  end

  def anonymous_content
    @rendered_template = Template.dynamic_page_content params[:template_type].to_sym
    render :content
  end
end
