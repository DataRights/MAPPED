class LettersController < ApplicationController

  before_action :set_letter
  before_action :authenticate_user!

  def download
    if @letter
      send_data(WickedPdf.new.pdf_from_string(@letter.final_text), :filename => "Letter-#{@letter.id}-#{@letter.workflow_transition.workflow.access_request.organization.name}", :type => :pdf)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_letter
      l = Letter.find(params[:id])
      if l.workflow_transition.workflow.access_request.user_id == current_user.id
        @letter = l
      end
    end
end
