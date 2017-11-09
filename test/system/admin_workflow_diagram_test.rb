require "application_system_test_case"

class AdminWorkflowDiagramTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit rails_admins_url
  #
  #   assert_selector "h1", text: "RailsAdmin"
  # end

  setup do
    @sample_email = 'mm.mani@gmail.com'
    @sample_password = 'eybaba13'
    User.create!(email: @sample_email, password_confirmation: @sample_password, password: @sample_password)
    @user = User.find_by(email: @sample_email)
    @user.confirm
  end

  teardown do
    User.find_by(email: @sample_email).destroy
    WorkflowTypeVersion.all.each do |w|
      file_path = Rails.root.join('public', "#{w.id}.png")
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  test "Test showing workflow diagram on rails admin" do
    visit('/admin')
    fill_in('user_email', with: @sample_email)
    fill_in('user_password', with: @sample_password)
    click_button I18n.t('devise.sign_in', default: 'Sign in')
    has_title = page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)
    take_screenshot unless has_title
    assert_equal true, has_title
    visit('/admin/workflow_type_version')
    page.all('a', text: I18n.t('workflow.generate_diagram')).each do |a|
      new_window = window_opened_by { a.click }
      within_window new_window do
        has_image = (page.all('img', id: 'workflow_diagram_img').count > 0)
        has_message = page.has_content?(I18n.t('workflow.no_state_to_generate_diagram'))
        assert(has_image || has_message)
      end
    end
  end
end
