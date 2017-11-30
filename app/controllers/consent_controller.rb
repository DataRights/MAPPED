class ConsentController < ApplicationController
  def show
    @tos = TermsOfService.find(params[:id])
    @tv = TemplateVersion.find_by(template_id: @tos.template_id, active: true)
    tc = TemplateContext.new
    tc.user = current_user
    @content = @tv.render(tc)
    @utos = UserTermsOfService.find_by user_id: current_user.id, terms_of_service_id: @ts.id
    if @utos.nil?
      @utos = UserTermsOfService.new
    end
  end
end
