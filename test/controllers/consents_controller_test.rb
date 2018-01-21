require 'test_helper'

class ConsentsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get consents_index_url
    assert_response :success

    upc1 = user_policy_consents(:one)
    upc2 = user_policy_consents(:two)
    upc3 = user_policy_consents(:three)
    assert_select 'table[id=consents]' do
      assert_select "tr#upc#{upc1.id}" do
        assert_select 'td:nth-child(1)', '1'
        assert_select 'td:nth-child(2)', upc1.policy_consent.title
        assert_select 'td:nth-child(3)', upc1.policy_consent.description
      end

      assert_select "tr#upc#{upc2.id}", false, "User policy consent 2 belongs to another user and should not be visible here!"

      assert_select "tr#upc#{upc3.id}" do
        assert_select 'td:nth-child(1)', '2'
        assert_select 'td:nth-child(2)', upc3.policy_consent.title
        assert_select 'td:nth-child(3)', upc3.policy_consent.description
      end
    end
  end

  test "should get show" do
    get consents_show_url
    assert_response :success
  end

  test "should get revoke" do
    assert_changes -> { user_policy_consents(:one).reload.approved } do
      delete revoke_consent_url(user_policy_consents(:one).id)
    end
    assert_redirected_to consents_index_url
  end
end
