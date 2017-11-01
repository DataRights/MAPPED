# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test 'can? should only accept valid actions' do
		exception = assert_raise (RuntimeError ) {User.new.can?(:an_invalid_action)}
		assert_equal 'Unknown Action(an_invalid_action)', exception.message
	end

	test 'can? should return true if user has a role which has the action' do
		researcher = roles(:researcher)
		access_rights(:researcher_view_user)

		user = users(:test_user)
		UserRole.create(user: user, role: researcher)

		assert user.can?(:view_user)
		assert_not user.can?(:create_user)

		admin = roles(:admin)
		access_rights(:admin_view_user)
		access_rights(:admin_create_user)

		UserRole.create(user: user, role: admin)
		assert user.can?(:view_user)
		assert user.can?(:create_user)
	end

end
