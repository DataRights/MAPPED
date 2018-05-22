class LettersController < ApplicationController

  before_action :set_letter
  before_action :authenticate_user!

  def download
    if @letter
      pdf = WickedPdf.new.pdf_from_string(@letter.final_text.html_safe, encoding: 'UTF-8')
      send_data(pdf, :filename => "Letter-#{@letter.id}-#{@letter.access_request_step.workflow.access_request.organization.name}", :type => :pdf)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_letter
      l = Letter.find(params[:id])
      if l.access_request_step.workflow.access_request.user_id == current_user.id
        @letter = l
      end
    end
end
