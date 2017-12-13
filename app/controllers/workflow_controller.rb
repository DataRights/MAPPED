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
    # TODO: check workflow to see if it belongs to current logged in user
    render json: {success: true, message: 'Workflow send event was successfull!'}, :status => :ok
  end
end
