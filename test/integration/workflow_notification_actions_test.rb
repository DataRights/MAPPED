require 'test_helper'

class WorkflowNotificationActionsTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "Code actions with notifications should insert a new notification record with specified template content and title into database." do
    wf = Workflow.new
    wf.workflow_type_version = workflow_type_versions(:version_one_point_o_mapped_social)
    wf.access_request = access_requests(:one)
    wf.save!
    assert_equal workflow_states(:waiting_for_ar_creation), wf.workflow_state

    t = transitions(:access_request_created)
    a = code_actions(:send_notification_with_template)
    template = templates(:reminder1)
    title = 'Your Access Request Status Update.'
    a.internal_data = { 'template_id': "#{template.id}", 'title': title}
    t.actions << a
    t.save!

    notifications_count_before_transition = Notification.count
    perform_enqueued_jobs do
      wt = wf.send_event(t)
      assert_equal 'success', wt.status, wt.to_json
      assert_equal wf.workflow_state, t.to_state
      assert_equal 3, wt.performed_actions.count
      action_names = []
      wt.performed_actions.each { |a| action_names << a['action_name'] }
      assert action_names.include?(a.name)

      assert_equal notifications_count_before_transition + 1, Notification.count
      expected_notification_content = "The access request #{wf.access_request.id} has been created on DataRights.me and it's ready for sending to organization #{wf.access_request.organization.name}. Currently status of your workflow is: #{t.from_state.name}"
      e = EmailNotification.last
      assert_equal expected_notification_content, e.notification.content
      assert_equal title, e.notification.title
      assert_equal 'sent', e.status, e.error_log

      mail = ActionMailer::Base.deliveries.last
      assert mail
      assert_equal [wf.access_request.user.email], mail.to, mail.inspect
      assert_equal e.notification.title, mail.subject, mail.inspect
      assert_equal e.notification.content, mail.body.parts.first.body.raw_source.gsub("\n",'')
    end
  end
end
