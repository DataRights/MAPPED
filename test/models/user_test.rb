# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  failed_attempts           :integer          default(0), not null
#  unlock_token              :string
#  locked_at                 :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  unconfirmed_email         :string
#  encrypted_otp_secret      :string
#  encrypted_otp_secret_iv   :string
#  encrypted_otp_secret_salt :string
#  consumed_timestep         :integer
#  otp_required_for_login    :boolean
#  first_name                :string
#  last_name                 :string
#  preferred_language        :string
#  custom_1                  :text
#  custom_2                  :text
#  custom_3                  :text
#  invitation_token          :string
#  invitation_created_at     :datetime
#  invitation_sent_at        :datetime
#  invitation_accepted_at    :datetime
#  invitation_limit          :integer
#  invited_by_type           :string
#  invited_by_id             :integer
#  invitations_count         :integer          default(0)
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

	test "the context_value" do
		assert_equal ({'email' => 'test@test.com'}), User.new(email: 'test@test.com').context_value
		assert_equal ({'email' => 'test@test.com', 'first_name' => 'John', 'last_name' => 'Smith'}), User.new(email: 'test@test.com', first_name: 'John', last_name: 'Smith').context_value
		assert_equal ({'email' => 'test@test.com', 'custom_1' => 'aaa'}), User.new(email: 'test@test.com', custom_1: 'aaa').context_value
		assert_equal ({'email' => 'test@test.com', 'custom_2' => 'aaa'}), User.new(email: 'test@test.com', custom_2: 'aaa').context_value
		assert_equal ({'email' => 'test@test.com', 'custom_3' => 'aaa'}), User.new(email: 'test@test.com', custom_3: 'aaa').context_value
	end

	test 'perferred_language should be a symbol' do
		assert_equal :en, User.new(email: 'test@test.com', preferred_language: :en).preferred_language
	end

	test 'enable_otp should generate an OTP secret and set otp_required_for_login to true and disable_otp! should set it to false again' do
		u = users(:one)
		assert_not u.otp_required_for_login
		u.enable_otp!
		assert u.otp_required_for_login
		assert_not u.otp_secret.blank?

		u.disable_otp!
		assert_not u.otp_required_for_login
	end

	test 'create new user without notification_type should set web_notification as the default' do
		User.create!(email: 'test@test12.com', password_confirmation: 'test123', password: 'test123')
		u = User.find_by email: 'test@test12.com'
		assert u.notification_settings.pluck(:notification_type).include?('web_notification'), u.notification_settings.pluck(:notification_type)
	end

	test 'cached_count should return accurate number and refresh cache on creation or deletion of users' do
		old_count = User.cached_count
		User.create!(email: 'test@test12.com', password_confirmation: 'test123', password: 'test123')
		assert_equal old_count + 1, User.cached_count
	end
end
