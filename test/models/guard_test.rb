# == Schema Information
#
# Table name: guards
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

class GuardTest < ActiveSupport::TestCase
  test "Guard check method should return result:success in case of failure, it should also fill message property." do
     g = guards(:simple_true_if)
     w = workflows(:one)
     resp = g.check(w)
     assert_equal true, resp[:result]
  end

  test "Guard check method should return result:false in case of failure, it should also fill message property." do
     g = guards(:simple_false_if)
     w = workflows(:one)
     resp = g.check(w)
     assert_equal false, resp[:result]
     assert_not_nil resp[:message]
  end

  test "Guard should have access to workflow and check the content of workflow and related objects" do
     g = guards(:check_something_in_workflow)
     w = workflows(:one)
     resp = g.check(w)
     assert_equal true, resp[:result]
     assert_not_nil resp[:message]

     w.workflow_state.name = 'something else'
     resp = g.check(w)
     assert_equal false, resp[:result]
     assert_not_nil resp[:message]
  end

  test "Guard validation should fail if class name doesn't exists in code base." do
    g = Guard.new
    g.name = 'check foo.bar'
    g.description = 'Checks to see if foo.bar returns true!'
    g.class_name = 'foo'
    g.method_name = 'bar'
    result = g.save
    assert_not result, 'Should return validation error for non existant class.'
    assert_equal 1, g.errors.count, "There should be one validation error: #{g.errors}"
    assert_equal 1, g.errors.messages[:class_name].count, "There should be one error about class_name in code: #{g.errors.messages[:class_name]}"
    assert_equal I18n.t('validations.invalid_class_name'), g.errors.messages[:class_name].first
  end

  test "Guard validation should fail if class exists but method name is not among valid methods for class." do
    g = Guard.new
    g.name = 'check foo.bar'
    g.description = 'Checks to see if foo.bar returns true!'
    g.class_name = 'GuardTestHelper'
    g.method_name = 'bar'
    result = g.save
    assert_not result, 'Should return validation error for non existant method_name.'
    assert_equal 1, g.errors.count, "There should be one validation error: #{g.errors}"
    assert_equal 1, g.errors.messages[:method_name].count, "There should be one error about class_name in code: #{g.errors.messages[:method_name]}"
    assert_equal I18n.t('validations.invalid_method_name'), g.errors.messages[:method_name].first
  end
end
