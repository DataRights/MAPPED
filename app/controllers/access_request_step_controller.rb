class AccessRequestStepController < ApplicationController

  before_action :authenticate_user!

  def update
    return unless params.include?(:access_request_step)
    wt_id = params[:access_request_step][:id]
    wt = AccessRequestStep.find(wt_id)
    @a = wt.workflow.access_request
    wt.remarks = params[:access_request_step][:remarks]
    wt.event_id = params[:access_request_step][:event_id]

    if params[:access_request_step].include?(:attachment_description)
      attachment = wt.attachments.first
      attachment.title = params[:access_request_step][:attachment_description]

      unless params[:access_request_step][:attachment_file].blank?
        attachment.content = params[:access_request_step][:attachment_file].read
        attachment.content_type = params[:access_request_step][:attachment_file].content_type
      end

      unless attachment.save
        @status = attachment.errors.full_messages
        return
      end
    end
    p "***********************************************************"
    p "Final text: #{params[:letter_text]}"
    p "***********************************************************"
    if params.include?(:letter_text)
      letter = wt.letters.first
      letter.final_text = params[:letter_text]
      unless letter.save
        @status = letter.errors.full_messages
        return
      end
    end

    if wt.save
      @status = 'success'
    else
      @status = wt.errors.full_messages
    end
  end
end
