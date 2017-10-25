require 'test_helper'

class RoleTest < ActiveSupport::TestCase
	test 'should have name' do
		role = Role.new
		assert_not role.valid?
	end

	test 'can? should only accept valid actions' do
		exception = assert_raise (RuntimeError ) {Role.new.can?(:an_invalid_action)}
		assert_equal 'Unknown Action(an_invalid_action)', exception.message
	end

	test 'can? should return true if action is in role list' do
		admin = roles(:admin)
		access_rights(:admin_view_user)
		access_rights(:admin_create_user)

		assert admin.can?(:view_user)
		assert admin.can?(:create_user)

		researcher = roles(:researcher)
		access_rights(:researcher_view_user)

		assert researcher.can?(:view_user)
		assert_not researcher.can?(:create_user)
	end
end
