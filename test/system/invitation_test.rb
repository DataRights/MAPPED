require 'application_system_test_case'

class InvitationTest < ApplicationSystemTestCase

  test 'Send standard invite' do
    # 1. Login
    assert_nil @user.encrypted_otp_secret # OTP is not enabled for user
    visit('/admin')
    fill_in('user_email', with: @sample_email)
    fill_in('user_password', with: @sample_password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    assert page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)

    user = User.find_by(email: 'test_invite@test.com')
    assert_not user

    visit(new_user_invitation_path)
    fill_in('user_email', with: 'test_invite@test.com')
    click_button I18n.t("devise.invitations.new.submit_button")

    assert_not ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    assert_equal 'Invitation instructions', mail.subject
    user = User.find_by(email: 'test_invite@test.com')
    assert user
    assert user.created_by_invite?
    user.destroy
  end

  test 'Send custom invite' do
    # Login
    assert_nil @user.encrypted_otp_secret # OTP is not enabled for user
    visit('/admin')
    fill_in('user_email', with: @sample_email)
    fill_in('user_password', with: @sample_password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    assert page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)

    user = User.find_by(email: 'test_invite@test.com')
    assert_not user

    visit(new_user_invitation_path)
    fill_in('user_email', with: 'test_invite@test.com')
    fill_in('customized_invitation_content', with: 'this is an invitation')
    click_button I18n.t("devise.invitations.new.submit_custom")
    assert_not ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    assert_equal I18n.t('devise.invitations.new.custom_email_subject'), mail.subject
    assert mail.body.parts.first.body.raw_source.include?('this is an invitation')
    user = User.find_by(email: 'test_invite@test.com')
    assert user
    assert user.created_by_invite?
    user.destroy
  end

  test 'Send custom invite with confirmation url' do
    # Login
    assert_nil @user.encrypted_otp_secret # OTP is not enabled for user
    visit('/admin')
    fill_in('user_email', with: @sample_email)
    fill_in('user_password', with: @sample_password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    assert page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)

    user = User.find_by(email: 'test_invite@test.com')
    assert_not user

    visit(new_user_invitation_path)
    fill_in('user_email', with: 'test_invite@test.com')
    fill_in('customized_invitation_content', with: 'click $ACCEPT_INVITATION_URL$ yes')
    click_button I18n.t("devise.invitations.new.submit_custom")
    assert_not ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    assert_equal I18n.t('devise.invitations.new.custom_email_subject'), mail.subject
    assert mail.body.parts.first.body.raw_source.include?('accept?invitation_token=')
    user = User.find_by(email: 'test_invite@test.com')
    assert user
    assert user.created_by_invite?
    user.destroy
  end

end
