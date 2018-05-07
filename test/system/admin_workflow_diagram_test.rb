require "application_system_test_case"

class AdminWorkflowDiagramTest < ApplicationSystemTestCase
  test "Test showing workflow diagram on rails admin" do
      visit('/admin')
      fill_in('user_email', with: @sample_email)
      fill_in('user_password', with: @sample_password)
      click_button I18n.t('devise.sign_in', default: 'Sign in')
      has_title = page.has_content?(I18n.t('admin.actions.dashboard.title').upcase)
      assert_equal true, has_title
      visit('/admin/workflow_type_version')
      page.all('a', text: I18n.t('workflow.generate_diagram')).each do |a|
        new_window = window_opened_by { a.click }
        within_window(new_window) do
          has_image = (page.all('img', id: 'workflow_diagram_img').count > 0)
          has_message = page.has_content?(I18n.t('workflow.no_state_to_generate_diagram'))
          assert(has_image || has_message)
        end
      end
  end
end
