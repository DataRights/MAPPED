require 'application_system_test_case'

class NewAccessRequestTest < ApplicationSystemTestCase
  test 'Create a new access request' do
    sign_in
    campaign = campaigns(:two)
    page.find("#join_campaign_#{campaign.id}").click
    assert_equal user_profile_for_campaign_path(campaign), page.current_path
    fill_in('user_first_name', with: 'James')
    fill_in('user_last_name', with: 'Smith')
    fill_in('user_address_attributes_line1', with: 'Test Line 1')
    fill_in('user_address_attributes_line2', with: 'Test Line 2')
    fill_in('user_address_attributes_post_code', with: '0152')
    fill_in('user_address_attributes_city_name', with: 'Victoria')
    canada = countries(:canada)
    select(canada.name, from: "user_address_attributes_country_id").select_option
    click_button I18n.t('users.edit.submit')
    assert page.has_content?(I18n.t('access_requests.index.approving_campaign_policy_consent_mandatory'))
    find('#user_user_policy_consents_attributes_0_approved').set(true)
    click_button I18n.t('users.edit.submit')
    assert_equal campaign_access_requests_path(campaign), page.current_path
    click_on I18n.t('common.create_new_ar')
    assert_equal new_campaign_access_request_path(campaign), page.current_path

    # Test loading only related organizations for sector and organizations that are available for current campaign
    sectors = find_field('access_request_sector_id').all('option').map { |s| s.value.to_i }
    sectors.each do |s|
      find_field('access_request_sector_id').find("option[value='#{s}']").click
      organization_ids = find_field('access_request_organization_id').all('option').map { |o| o.value.to_i }
      organization_ids.each do |o|
        assert_equal s, Organization.find(o).sector_id
      end
      Organization.where(sector_id: s).each do |o|
        if o.campaigns.include?(campaign)
          assert_includes organization_ids, o.id
        else
          refute_includes organization_ids, o.id
        end
      end

      sector = Sector.find s
      templates = sector.templates.where(template_type: :access_request)
      templates.each do |t|
        template_versions = t.template_versions.where(active: true)
        assert_equal template_versions.count, find_field('access_request_template_version_id').all('option').count, sector.name
        template_versions.each do |tv|
          find_field('access_request_template_version_id').find("option[value='#{tv.id}']").click
        end
      end
    end
  end
end
