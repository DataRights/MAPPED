class WorkflowController < ApplicationController
  before_action :authenticate_user!

  def diagram
    w = WorkflowTypeVersion.find_by(id: params[:id])
    unless w
      flash[:notice] = I18n.t('invalid_parameters')
      return
    end
    if w.generate_dot_diagram
      @diagram_path = "#{w.diagram_path}?version=#{Time.now.to_i}"
    else
      flash[:notice] = I18n.t('workflow.no_state_to_generate_diagram')
    end
  end

  def send_event
    workflow_id = params[:workflow][:id]
    transition_id = params[:workflow][:transition_id]
    attachment = nil
    wf = Workflow.find(workflow_id)
    return unless wf.access_request.user_id == current_user.id
    t = Transition.find(transition_id)
    @workflow_transition = wf.send_event(t, params[:workflow][:event_id], params[:workflow][:remarks])

    if params[:workflow][:attachment_file] && params[:workflow][:attachment_file].count > 0
      params[:workflow][:attachment_file].each do |f|
        attachment = Attachment.new
        attachment.content = f.read
        attachment.content_type = f.content_type
        if params[:workflow][:attachment_description] && !params[:workflow][:attachment_description].blank?
          attachment.title = params[:workflow][:attachment_description]
        else
          attachment.title = f.original_filename
        end
        attachment.workflow_transition_id = @workflow_transition.id
        attachment.save!
      end
    end

    if params[:workflow][:current_form] == 'send_letter'
      l = Letter.new
      l.sent_date = params[:sent_date]
      l.workflow_transition_id = @workflow_transition.id
      l.suggested_text = params[:standard_text]
      if params[:textTypeRadios] == 'expanded'
        l.final_text = params[:custom_text]
      else
        l.final_text = params[:standard_text]
      end
      l.letter_type = params[:workflow][:letter_type]
      l.save!
    end

    @ar = wf.access_request
    if params[:workflow][:sent_date]
      @ar.sent_date = params[:workflow][:sent_date]
      @ar.save!
    end

    if params['commit'] == I18n.t('access_requests.templates.evaluation.evaluate')
      params['answers'].each do |answer_id|
        a = Answer.find_by(question_id: answer_id.to_i, answerable_type: 'AccessRequest', answerable_id: @ar.id)
        if a
          a.result = params['answers'][answer_id]
          a.save!
        else
          Answer.create( result: params['answers'][answer_id], answerable_type: 'AccessRequest', answerable_id: @ar.id, question_id: answer_id.to_i)
        end
      end
    end

    if attachment && params[:workflow].include?(:do_blackout) && params[:workflow][:do_blackout] == "1"
      redirect_to edit_attachment_path(attachment)
    end
  end

  def undo
    wt = WorkflowTransition.find_by(id: params[:workflow_transition_id])
    return unless wt.workflow.access_request.user_id == current_user.id
    result = wt.workflow.undo
    if result[:success] == true
      flash[:success] = result[:message]
    else
      flash[:alert] = result[:message]
    end
    redirect_to campaign_access_requests_path(wt.workflow.access_request.campaign)
  end
end
