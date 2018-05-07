require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  setup do
    @sample_email = 'john@smith.com'
    @sample_password = '1234567890'
    User.create!(email: @sample_email, password_confirmation: @sample_password, password: @sample_password, approved: true, roles: [Role.find_by(name: roles(:admin).name)])
    @user = User.find_by(email: @sample_email)
    @user.confirm
  end

  teardown do
    User.find_by(email: @sample_email).destroy
  end

  def sign_in
    visit(new_user_session_path)
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: @sample_password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    assert campaigns_path, page.current_path
  end
end
