class WorkflowTransitionController < ApplicationController
  def update
    return unless params.include?(:workflow_transition)
    wt_id = params[:workflow_transition][:id]
    wt = WorkflowTransition.find(wt_id)
    @a = wt.workflow.access_request
    wt.remarks = params[:workflow_transition][:remarks]
    wt.event_id = params[:workflow_transition][:event_id]

    if params[:workflow_transition].include?(:attachment_description)
      attachment = wt.attachments.first
      attachment.title = params[:workflow_transition][:attachment_description]

      unless params[:workflow_transition][:attachment_file].blank?
        attachment.content = params[:workflow_transition][:attachment_file].read
        attachment.content_type = params[:workflow_transition][:attachment_file].content_type
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
