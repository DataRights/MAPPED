class CorrespondencesController < ApplicationController

  before_action :set_correspondence
  before_action :authenticate_user!

  def download
    if @oc.final_text
      pdf = WickedPdf.new.pdf_from_string(@oc&.final_text&.html_safe, encoding: 'UTF-8')
      send_data(pdf, filename: "oc-#{@oc.id}-#{@oc.access_request_step.workflow.access_request.organization.name}", type: :pdf)
    elsif @oc.attachments.first
      send_data(@oc.attachments.first.content, filename: "Correspondence-#{@oc.id}-#{@oc.access_request_step.workflow.access_request.organization.name}", type: @oc.attachments.first.content_type)
    else
      pdf = WickedPdf.new.pdf_from_string('', encoding: 'UTF-8')
      send_data(pdf, filename: "oc-#{@oc.id}-#{@oc.access_request_step.workflow.access_request.organization.name}", type: :pdf)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_correspondence
    l = Correspondence.find(params[:id])
    return unless l.access_request_step.workflow.access_request.user_id == current_user.id
    @oc = l
  end
end
