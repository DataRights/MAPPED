require "application_system_test_case"

class TwoFactorAuthTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit two_factor_auths_url
  #
  #   assert_selector "h1", text: "TwoFactorAuth"
  # end

  setup do
    @sample_email = 'john@smith.com'
    @sample_password = '1234567890'
    User.create!(email: @sample_email, password_confirmation: @sample_password, password: @sample_password)
    @user = User.find_by(email: @sample_email)
    @user.confirm
  end

  teardown do
    User.find_by(email: @sample_email).destroy
  end

  test "All two factor authentication scenarios" do
      # 1. Login
      visit('/admin')
      fill_in('user_email', with: @sample_email)
      fill_in('user_password', with: @sample_password)
      click_button I18n.t('devise.sign_in', default: 'Sign in')
      assert page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)

      # 2. Enable TFA
      visit(users_tfa_path)
      click_button I18n.t('tfa.enable')

      # 3. Logout
      visit('/admin')
      click_on I18n.t('admin.misc.log_out')
      visit('/admin')

      # 4. Try to login without TFA should fail
      fill_in('user_email', with: @sample_email)
      fill_in('user_password', with: @sample_password)
      click_button I18n.t('devise.sign_in', default: 'Sign in')
      assert_text I18n.t('devise.failure.invalid', authentication_keys: 'Email')

      # 5. Try to login with wrong one time password should also fail
      fill_in('user_email', with: @sample_email)
      fill_in('user_password', with: @sample_password)
      fill_in('user_otp_attempt', with: '123456')
      click_button I18n.t('devise.sign_in', default: 'Sign in')
      assert_text I18n.t('devise.failure.invalid', authentication_keys: 'Email')

      # 6. Login with right one time password should work
      fill_in('user_email', with: @sample_email)
      fill_in('user_password', with: @sample_password)
      @user.reload
      fill_in('user_otp_attempt', with: @user.current_otp)
      click_button I18n.t('devise.sign_in', default: 'Sign in')
      assert page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)

      # 7. Disable OTP
      visit(users_tfa_path)
      click_button I18n.t('tfa.disable')

      # 8. Logout
      visit('/admin')
      click_on I18n.t('admin.misc.log_out')

      # 9. Should be able to login without one time password
      visit('/admin')
      fill_in('user_email', with: @sample_email)
      fill_in('user_password', with: @sample_password)
      click_button I18n.t('devise.sign_in', default: 'Sign in')
      assert page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)
  end
end
