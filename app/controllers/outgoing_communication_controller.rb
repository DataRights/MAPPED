class OutgoingCommunicationController < ApplicationController

  before_action :set_outgoing_communication
  before_action :authenticate_user!

  def download
    if @oc
      pdf = WickedPdf.new.pdf_from_string(@oc.final_text.html_safe, encoding: 'UTF-8')
      send_data(pdf, :filename => "oc-#{@oc.id}-#{@oc.workflow_transition.workflow.access_request.organization.name}", :type => :pdf)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outgoing_communication
      l = OutgoingCommunication.find(params[:id])
      if l.workflow_transition.workflow.access_request.user_id == current_user.id
        @oc = l
      end
    end
end
