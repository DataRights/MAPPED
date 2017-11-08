class WorkflowController < ApplicationController
  def diagram
    unless params.include?(:id)
      flash[:notice] = I18n.t('invalid_parameters')
      return
    end
    w = WorkflowTypeVersion.find_by(id: params[:id])
    unless w
      flash[:notice] = I18n.t('invalid_parameters')
      return
    end

    if w.generate_dot_diagram
      @diagram_path = w.diagram_path
    else
      flash[:notice] = I18n.t('workflow.no_state_to_generate_diagram')
    end
  end
end
