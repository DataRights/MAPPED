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
      if params[:workflow][:access_request_sent_date]
        c = @ar.correspondences.where(correspondence_type: :access_request).first
        c.correspondence_date = params[:workflow][:access_request_sent_date]
        c.medium = params[:workflow][:correspondence_medium]
        c.remarks = params[:workflow][:remarks]
        c.save!
      end
      t = Transition.find(transition_id)
      @errors = nil
      @access_request_step = wf.send_event(t, params[:workflow][:event_id], params[:workflow][:remarks])
      unless @access_request_step.status == 'success'
        @errors = "#{@access_request_step.action_failed_message} - #{@access_request_step.failed_guard_message}"
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
          attachment.attachable = @access_request_step
          attachment.user = current_user
          unless attachment.save
            @errors = attachment.errors.full_messages.join(". ")
            raise ActiveRecord::Rollback
          end
        end
      end

      if params[:workflow][:ui_form] && params[:workflow][:ui_form] == 'response_received'
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
            attachment.attachable = access_request_step
            attachment.user = current_user
            unless attachment.save
              @errors = attachment.errors.full_messages.join(". ")
              raise ActiveRecord::Rollback
            end
          end
        end
      end

      if params[:workflow][:current_form] == 'send_letter'
        oc = Correspondence.new
        oc.correspondence_date = params[:sent_date]
        oc.workflow_transition_id = @access_request_step.id
        oc.suggested_text = params[:standard_text]
        if params[:textTypeRadios] == 'expanded'
          oc.final_text = params[:custom_text]
        else
          oc.final_text = params[:standard_text]
        end
        oc.communication_type = params[:workflow][:letter_type]
        unless oc.save
          @errors = oc.errors.full_messages.join(". ")
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
    wt = AccessRequestStep.find_by(id: params[:access_request_step_id])
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
