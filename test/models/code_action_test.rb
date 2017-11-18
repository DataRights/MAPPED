# == Schema Information
#
# Table name: code_actions
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :string
#  class_name    :string
#  method_name   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  internal_data :jsonb
#

require 'test_helper'

class CodeActionTest < ActiveSupport::TestCase
  test "Action execute method should return true in case of success and a message" do
     a = code_actions(:send_a_reminder)
     w = workflows(:one)
     resp = a.execute(w)
     assert_equal true, resp[:result]
     assert_not_nil resp[:message]
     assert_equal "reminder successfully sent to workflow in state: #{w.workflow_state.name}", resp[:message]
  end

  test "Action execute method should return false and an error in case of failure" do
     a = code_actions(:apply_tag_in_database)
     w = workflows(:one)
     resp = a.execute(w)
     assert_equal false, resp[:result]
     assert_not_nil resp[:message]
     assert_equal "tag failed to apply to workflow in state: #{w.workflow_state.name}", resp[:message]
  end

  test "Action validation should fail if class name doesn't exists in code base." do
    a = CodeAction.new
    a.name = 'check foo.bar'
    a.description = 'Checks to see if foo.bar returns true!'
    a.class_name = 'foo'
    a.method_name = 'bar'
    result = a.save
    assert_not result, 'Should return validation error for non existant class.'
    assert_equal 1, a.errors.count, "There should be one validation error: #{a.errors}"
    assert_equal 1, a.errors.messages[:class_name].count, "There should be one error about class_name in code: #{a.errors.messages[:class_name]}"
    assert_equal I18n.t('validations.invalid_class_name'), a.errors.messages[:class_name].first
  end

  test "Action validation should fail if class exists but method name is not among valid methods for class." do
    a = CodeAction.new
    a.name = 'check foo.bar'
    a.description = 'Checks to see if foo.bar returns true!'
    a.class_name = 'ActionTestHelper'
    a.method_name = 'bar'
    result = a.save
    assert_not result, 'Should return validation error for non existant method_name.'
    assert_equal 1, a.errors.count, "There should be one validation error: #{a.errors}"
    assert_equal 1, a.errors.messages[:method_name].count, "There should be one error about class_name in code: #{a.errors.messages[:method_name]}"
    assert_equal I18n.t('validations.invalid_method_name'), a.errors.messages[:method_name].first
  end

  test 'Action validation should succeed if the method name exists for the specified class name' do
    a = CodeAction.new
    a.name = 'Success Action without rollback'
    a.description = 'A sample action for test which returns success but does not support rollback!'
    a.class_name = 'ActionTestHelper'
    a.method_name = 'another_sample_action'
    result = a.save
    assert_equal true, result, a.errors.messages

    expected_exec_result = { result:true, message:'Success!' }
    expected_rollback_result = { result:false, message:I18n.t('rollback_method_does_not_exist_for_action') }
    assert_equal expected_exec_result, a.execute(nil)
    assert_equal expected_rollback_result, a.rollback(nil)
  end

  test 'If you not pass internal_data to an action that requires internal data validation should fail' do
    a = CodeAction.new
    a.name = 'Notification sender'
    a.description = 'This action sends notificaitons to their user, type of notification depends on preferences chosen by end-user'
    a.class_name = 'NotificationActionsHelper'
    a.method_name = 'send_notification_with_template'
    result = a.save
    assert_equal false, result
    assert_equal 2, a.errors.count, "There should be two validation error: #{a.errors.messages}"
    assert_equal 1, a.errors.messages[:internal_data].count, "There should be one error about class_name in code: #{a.errors.messages[:internal_data]}"
    assert_equal I18n.t('validations.action_internal_data_required'), a.errors.messages[:internal_data].first
  end
end
