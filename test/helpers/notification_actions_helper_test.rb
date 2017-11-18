class NotificationActionsHelperTest < ActionView::TestCase
  test "internal data should have template_id and title parameters" do
    result = NotificationActionsHelper::send_notification_with_template(workflows(:one), {"name": "mani"})
    assert_not result[:success]
    assert_equal I18n.t('validations.template_id_mandatory_internal_data'), result[:message], result
  end

  test "send_notification_with_template should fail with appropriate error if passed template_id is wrong" do
    result = NotificationActionsHelper::send_notification_with_template(workflows(:one), {"title": "mani", "template_id": 12})
    assert_not result[:success]
    assert_equal I18n.t('validations.template_id_not_found'), result[:message], result
  end

  test "send_notification_with_template should fail with appropriate error if persistance of Notification fails" do
    wf = workflows(:one)
    wf.access_request.user = nil
    result = NotificationActionsHelper::send_notification_with_template(wf, {"title": "mani", "template_id": templates(:ar).id})
    assert_not result[:success]
    assert result[:message].include?(I18n.t('notificaitons.insert_failed', errors:'')), result[:message]
  end
end
