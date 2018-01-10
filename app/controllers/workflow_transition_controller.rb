class WorkflowTransitionController < ApplicationController
  def update
    wt_id = params[:workflow_transition][:id]
    wt = WorkflowTransition.find(wt_id)
    wt.remarks = params[:workflow_transition][:remarks]
    wt.event_id = params[:workflow_transition][:event_id]
    @a = wt.workflow.access_request
    if wt.save
      @status = 'success'
    else
      @status = wt.errors.full_messages
    end
  end
end
