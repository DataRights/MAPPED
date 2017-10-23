require 'test_helper'

class RoleTest < ActiveSupport::TestCase
	test 'should have name' do
		role = Role.new
		assert_not role.valid?
	end
end
