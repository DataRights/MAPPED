require 'application_system_test_case'

class CreateEditAccessRequestTest < ApplicationSystemTestCase

  include ERB::Util

  def rendered_template_version(tv, campaign, organization)
    context = TemplateContext.new
    context.campaign = campaign
    context.user = @user
    context.organization = organization
    tv.render(context)
  end

  test 'before creating AR, consent and personal information, changing sector, organization and templates' do
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
        sector = Sector.find s
        templates = sector.templates.where(template_type: :access_request)
        templates.each do |t|
          template_versions = t.template_versions.where(active: true)
          assert_equal template_versions.count, find_field('access_request_template_version_id').all('option').count, sector.name
          template_versions.each do |tv|
            find_field('access_request_template_version_id').find("option[value='#{tv.id}']").click
            assert_equal rendered_template_version(tv, campaign, Organization.find(o)), get_ckeditor_value('1_contents')
          end
        end
      end
      Organization.where(sector_id: s).each do |o|
        if o.campaigns.include?(campaign)
          assert_includes organization_ids, o.id
        else
          refute_includes organization_ids, o.id
        end
      end
    end
  end

  test 'Create access request by uploading existing file' do
    sign_in
    campaign = campaigns(:two)
    update_user_info(campaign)
    visit new_campaign_access_request_path(campaign)
    assert_equal new_campaign_access_request_path(campaign), page.current_path
    choose("access_request_ar_method_upload", option: "upload")
    attach_file('access_request_uploaded_access_request_file', "#{Rails.root}/test/files/ar1.png")
    click_on I18n.t('access_requests.form.submit_upload_ar')
    assert_equal campaign_access_requests_path(campaign), page.current_path
    ar = AccessRequest.find_by(user_id: @user.id, campaign_id: campaign.id)
    assert_not_nil ar
    assert_nil ar.access_request_file
    assert_nil ar.access_request_file_content_type
    assert_not_nil ar.attachments.first
    assert_not_nil ar.attachments.first.content
    assert_equal 'image/png', ar.attachments.first.content_type

    # Test edit access request
    find("#triangle_#{ar.id}").click
    find("#edit_access_request_#{ar.id}").click
    assert_equal edit_campaign_access_request_path(campaign_id: ar.campaign_id, id: ar.id), page.current_path

    # Sumitting with an empty file should fail with error
    click_on I18n.t('access_requests.form.submit_upload_ar')
    assert_equal edit_campaign_access_request_path(campaign_id: ar.campaign_id, id: ar.id), page.current_path
    assert page.body.include?("#{I18n.t('activerecord.attributes.attachment.content')} #{I18n.t('activerecord.errors.models.attachment.attributes.content.blank')}")

    # Attaching a file and editing access request should succeed
    attach_file('access_request_uploaded_access_request_file', "#{Rails.root}/test/files/ar2.jpg")
    click_on I18n.t('access_requests.form.submit_upload_ar')
    assert_equal campaign_access_requests_path(campaign), page.current_path
    ar.reload
    a = ar.attachments.first
    assert_not_nil a
    assert_not_nil a.content
    assert_equal 'image/jpeg', a.content_type
    assert_equal 'ar2.jpg', a.title
  end

  test 'Create access request by using existing templates' do
    sign_in
    campaign = campaigns(:two)
    update_user_info(campaign)
    visit new_campaign_access_request_path(campaign)
    assert_equal new_campaign_access_request_path(campaign), page.current_path
    choose("access_request_ar_method_template", option: "template")

    # select transport sector
    sector = sectors(:transport)
    find_field('access_request_sector_id').find("option[value='#{sector.id}']").click
    rendered_template = ''
    organization_ids = find_field('access_request_organization_id').all('option').map { |o| o.value.to_i }
    organization_ids.each do |o|
      assert_equal sector.id, Organization.find(o).sector_id
      templates = sector.templates.where(template_type: :access_request)
      templates.each do |t|
        template_versions = t.template_versions.where(active: true)
        assert_equal template_versions.count, find_field('access_request_template_version_id').all('option').count, sector.name
        template_versions.each do |tv|
          find_field('access_request_template_version_id').find("option[value='#{tv.id}']").click
          rendered_template = rendered_template_version(tv, campaign, Organization.find(o))
          assert_equal rendered_template, get_ckeditor_value('1_contents')
        end
      end
    end

    click_on I18n.t('access_requests.form.final_button')
    assert_equal campaign_access_requests_path(campaign), page.current_path
    ar = AccessRequest.find_by(user_id: @user.id, campaign_id: campaign.id)
    assert_not_nil ar
    assert ar.final_text.include?(html_escape(rendered_template))

    # Test edit access request
    find("#triangle_#{ar.id}").click
    find("#edit_access_request_#{ar.id}").click
    assert_equal edit_campaign_access_request_path(campaign_id: ar.campaign_id, id: ar.id), page.current_path
    new_text = 'Test 1, 2, 3.'
    fill_in_ckeditor('1_contents', with: new_text)
    click_on I18n.t('access_requests.form.final_button')
    assert_equal campaign_access_requests_path(campaign), page.current_path
    ar.reload
    assert ar.final_text.include?(new_text)

    # Test edit access request with empty text
    assert_equal campaign_access_requests_path(campaign), page.current_path
    find("#triangle_#{ar.id}").click
    find("#edit_access_request_#{ar.id}").click
    assert_equal edit_campaign_access_request_path(campaign_id: ar.campaign_id, id: ar.id), page.current_path
    fill_in_ckeditor('1_contents', with: ' ')
    click_on I18n.t('access_requests.form.final_button')
    assert_equal edit_campaign_access_request_path(campaign_id: ar.campaign_id, id: ar.id), page.current_path
    assert page.body.include?(I18n.t('validations.final_text_empty'))
  end

  test 'test add new organization in new access request page' do
    sign_in
    campaign = campaigns(:two)
    update_user_info(campaign)
    visit new_campaign_access_request_path(campaign)
    assert_equal 0, Organization.where(name: 'Facebook').count
    click_on I18n.t('access_requests.form.click_here')
    fill_in('organization[name]', with: 'Facebook Inc.')
    fill_in('organization[privacy_policy_url]', with: "https://www.facebook.com/privacy")
    fill_in('organization[address_attributes][email]', with: 'info@facebook.com')
    fill_in('organization[address_attributes][line1]', with: '1 Hacker Way')
    fill_in('organization[address_attributes][line2]', with: ' ')
    fill_in('organization[address_attributes][post_code]', with: '0152')
    fill_in('organization[address_attributes][city_name]', with: 'Menlo Park, California')
    find_field('organization[address_attributes][country_id]').find("option[value='#{countries(:usa).id}']").click
    find('#new_organization_submit').click
    submit_btn = first('#new_organization_submit')
    loop until submit_btn.nil? or submit_btn.value != I18n.t('access_requests.form.saving')
    o = Organization.find_by(name: 'Facebook Inc.')
    assert o
    assert_equal 'Others', o.sector.name
    assert_equal o.sector.id, find_field('access_request_sector_id').value.to_i
    assert_equal o.id, find_field('access_request_organization_id').value.to_i
    ar_text = 'Access Request to Facebook Inc.'
    fill_in_ckeditor_with_class('cke_contents', with: ar_text)
    click_on I18n.t('access_requests.form.final_button')
    assert_equal campaign_access_requests_path(campaign), page.current_path
    ar = AccessRequest.find_by(user_id: @user.id, campaign_id: campaign.id)
    assert ar.final_text.include?(ar_text)
  end
end
