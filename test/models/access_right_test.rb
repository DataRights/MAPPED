require 'test_helper'

class AccessRightTest < ActiveSupport::TestCase
  test "action should be from the ACTION list" do
	  role = Role.new(name: 'admin')

	  access_right = AccessRight.new(role: role, action: :an_invalid_action)
	  assert_not access_right.valid?

	  access_right = AccessRight.new(role: role, action: :view_user)
	  assert access_right.valid?
  end
end
