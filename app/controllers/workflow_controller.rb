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
    ActiveRecord::Base.transaction do
      workflow_id = params[:workflow][:id]
      transition_id = params[:workflow][:transition_id]
      attachment = nil
      wf = Workflow.find(workflow_id)
      return unless wf.access_request.user_id == current_user.id
      @ar = wf.access_request
      t = Transition.find(transition_id)
      @errors = nil
      @workflow_transition = wf.send_event(t, params[:workflow][:event_id], params[:workflow][:remarks])
      unless @workflow_transition.status == 'success'
        @errors = "#{@workflow_transition.action_failed_message} - #{@workflow_transition.failed_guard_message}"
        return
      end

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
          attachment.attachable = @workflow_transition
          attachment.user = current_user
          unless attachment.save
            @errors = attachment.errors.full_messages.join(". ")
            raise ActiveRecord::Rollback
          end
        end
      end

      if params[:workflow][:ui_form] && params[:workflow][:ui_form] == 'response_received'
        response = Response.new
        response.response_type = ResponseType.find(params[:workflow][:response_type_id])
        response.description = params[:workflow][:response_description]
        response.received_date = params[:workflow][:response_received_date]
        response.access_request_id = wf.access_request.id
        unless response.save
          @errors = response.errors.full_messages.join(". ")
          raise ActiveRecord::Rollback
        end

        if params[:workflow][:response_attachment_file] && params[:workflow][:response_attachment_file].count > 0
          params[:workflow][:response_attachment_file].each do |f|
            attachment = Attachment.new
            attachment.content = f.read
            attachment.content_type = f.content_type
            if params[:workflow][:response_attachment_title] && !params[:workflow][:response_attachment_title].blank?
              attachment.title = params[:workflow][:response_attachment_title]
            else
              attachment.title = f.original_filename
            end
            attachment.attachable = response
            attachment.user = current_user
            unless attachment.save
              @errors = attachment.errors.full_messages.join(". ")
              raise ActiveRecord::Rollback
            end
          end
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
        unless l.save
          @errors = l.errors.full_messages.join(". ")
          raise ActiveRecord::Rollback
        end
      end

      if params[:workflow][:sent_date]
        @ar.sent_date = params[:workflow][:sent_date]
        @ar.sending_method_id = params[:workflow][:sending_method_id]
        @ar.sending_method_remarks = params[:workflow][:remarks]
        unless @ar.save
          @errors = @ar.errors.full_messages.join(". ")
          raise ActiveRecord::Rollback
        end
      end

      if params['commit'] == I18n.t('access_requests.templates.evaluation.evaluate')
        params['answers'].each do |answer_id|
          a = Answer.find_by(question_id: answer_id.to_i, answerable_type: 'AccessRequest', answerable_id: @ar.id)
          if a
            a.result = params['answers'][answer_id]
          else
            a = Answer.new
            a.result = params['answers'][answer_id]
            a.answerable_type = 'AccessRequest'
            a.answerable_id = @ar.id
            a.question_id = answer_id.to_i
          end

          unless a.save
            @errors = a.errors.full_messages.join(". ")
            raise ActiveRecord::Rollback
          end
        end
      end
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
