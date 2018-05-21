module NotificationActionsHelper
  def self.send_notification_with_template(workflow, internal_data)
    internal_data = internal_data&.with_indifferent_access
    unless internal_data.include?('template_id') and internal_data.include?('title')
      return { result: false, message: I18n.t('validations.template_id_mandatory_internal_data') }
    end
    tv = Template.find_by template_id: internal_data['template_id'], active: true
    unless tv
      return {result: false, message: I18n.t('validations.template_id_not_found')}
    end

    c = TemplateContext.new
    c.user = workflow.access_request.user
    c.organization = workflow.access_request.organization
    c.campaign = workflow.access_request.campaign
    c.workflow = workflow
    c.access_request = workflow.access_request

    n = Notification.new
    n.content = tv.render(c)
    n.title = internal_data['title']
    n.user = workflow.access_request.user
    n.access_request = workflow.access_request

    if n.save
      { result: true, message: n.to_json }
    else
      { result: false, message: I18n.t('notificaitons.insert_failed', errors: n.errors.messages)}
    end
  end
end
