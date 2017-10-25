# == Schema Information
#
# Table name: actions
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  class_name  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  method_name :string
#

require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  test "Action execute method should return true in case of success and a message" do
     a = actions(:send_a_reminder)
     w = workflows(:one)
     resp = a.execute(w)
     assert_equal true, resp[:result]
     assert_not_nil resp[:message]
     assert_equal "reminder successfully sent to workflow in state: #{w.workflow_state.name}", resp[:message]
  end

  test "Action execute method should return false and an error in case of failure" do
     a = actions(:apply_tag_in_database)
     w = workflows(:one)
     resp = a.execute(w)
     assert_equal false, resp[:result]
     assert_not_nil resp[:message]
     assert_equal "tag failed to apply to workflow in state: #{w.workflow_state.name}", resp[:message]
  end

  test "Action validation should fail if class name doesn't exists in code base." do
    a = Action.new
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
    a = Action.new
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
end
