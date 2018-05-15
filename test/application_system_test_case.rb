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

  def update_user_info(campaign)
    pc = campaign.policy_consent
    pc = PolicyConsent.find_by(type_of: :campaign) if pc.nil?
    return unless pc
    upc = UserPolicyConsent.find_or_create_by user_id: @user.id, policy_consent_id: pc.id
    u = {
      first_name: 'John', last_name: 'Smith', preferred_language: 'en', campaign_id: campaign.id,
      :notification_setting_ids => [NotificationSetting.first.id],
      :address_attributes => {line1: 'Test Line 1', line2: 'Test Line 2', post_code: '0152', city_name: 'Vancouver', country_id: countries(:canada).id},
      :user_policy_consents_attributes => [id: upc.id, approved: true, content: 'test']
    }
    @user.update(u)
  end

  def fill_in_ckeditor(id, with:)
    within_frame find("#cke_#{id} iframe") do
      find('body').base.set with
    end
  end

  def fill_in_ckeditor_with_class(css_class, with:)
    within_frame find(".#{css_class} iframe") do
      find('body').base.set with
    end
  end

  def get_ckeditor_value(id)
    within_frame find("#cke_#{id} iframe") do
      find('body').base.all_text
    end
  end
end
