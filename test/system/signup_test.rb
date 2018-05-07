require 'application_system_test_case'

class SignupTest < ApplicationSystemTestCase
  test 'sign up and confirm email scenario' do
    visit('/')
    email = "b#{rand(1..100)}@bar.com"
    password = 'bar123'
    fill_in('user_email', with: email)
    fill_in('user_password', with: password)
    fill_in('user_password_confirmation', with: password)
    click_button I18n.t('devise.sign_up', default: 'Sign Up')
    assert page.has_content?(I18n.t('devise.registrations.signed_up_but_unconfirmed'))

    path_regex = /(?:"http?\:\/\/.*?)(\/.*?)(?:")/
    last_email = ActionMailer::Base.deliveries.last
    path = last_email.body.match(path_regex)[1]
    visit(path)
    user = User.find_by(email: email)
    assert user.confirmed?

    visit(new_user_session_path)
    fill_in('user_email', with: email)
    fill_in('user_password', with: password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    assert campaigns_path, page.current_path
  end

  # see details here: https://github.com/datarights/DataInSight/issues/126
  test 'Testing user approval flow from unallowed domains' do
    Setting.where(key: 'auto_approved_user_domains').update_all(value: 'foo.com')
    visit('/')
    email = "b#{rand(1..100)}@bar.com"
    password = 'bar123'
    fill_in('user_email', with: email)
    fill_in('user_password', with: password)
    fill_in('user_password_confirmation', with: password)
    click_button I18n.t('devise.sign_up', default: 'Sign Up')
    assert page.has_content?(I18n.t('devise.registrations.user.signed_up_but_not_approved'))

    # Trying to sign in should fail since account account is not approved yet
    visit(new_user_session_path)
    fill_in('user_email', with: email)
    fill_in('user_password', with: password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    assert page.has_content?(I18n.t('devise.failure.not_approved'))

    # Trying to sign up from an allowed domain should work
    visit('/')
    email = "b#{rand(1..100)}@foo.com"
    fill_in('user_email', with: email)
    fill_in('user_password', with: password)
    fill_in('user_password_confirmation', with: password)
    click_button I18n.t('devise.sign_up', default: 'Sign Up')
    assert page.has_content?(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
  end
end
