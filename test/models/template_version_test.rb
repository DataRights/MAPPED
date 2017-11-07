# == Schema Information
#
# Table name: template_versions
#
#  id          :integer          not null, primary key
#  version     :string
#  template_id :integer
#  content     :text
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class TemplateVersionTest < ActiveSupport::TestCase
  test "render exception handling" do
    assert_equal '', TemplateVersion.new.render(nil)

    exception = assert_raise (RuntimeError ) {TemplateVersion.new(content: 'This is a template').render(nil)}
    assert_equal 'Invalid context', exception.message

    exception = assert_raise (RuntimeError ) {TemplateVersion.new(content: 'This is a template').render('wrong context')}
    assert_equal 'Wrong context type', exception.message

    assert_equal 'This is a template', TemplateVersion.new(content: 'This is a template').render(TemplateContext.new)
  end

  test "render with simple context" do
    template_content = "This is a template with context\n {{ user.email }}\n Sending access request to {{ organization.name }} "
    render_result    = "This is a template with context\n test123@test.com\n Sending access request to Schiphol Airport "
    assert_equal render_result, TemplateVersion.new(content: template_content).render(TemplateContext.new(user: User.new(email: 'test123@test.com'), organization: Organization.new(name: 'Schiphol Airport')))
  end

  test "render with context with organization with address" do
    template_content = "The address of {{ organization.name }}\n line1 {{ organization.addresses[0].line1 }}\n city  {{ organization.addresses[0].city.name }}"
    render_result    = "The address of Schiphol Airport\n line1 somewhere\n city  London"
    organization = Organization.new(name: 'Schiphol Airport')
    organization.addresses << Address.new(line1: 'somewhere', city: City.new(name: 'London'))
    assert_equal render_result, TemplateVersion.new(content: template_content).render(TemplateContext.new(organization: organization))
  end

  test "render with context with user with address" do
    template_content = "The address of {{ user.email }}\n line1 {{ user.addresses[0].line1 }}\n country  {{ user.addresses[0].country.name }}"
    render_result    = "The address of test123@test.com\n line1 somewhere\n country  UK"
    user = User.new(email: 'test123@test.com')
    user.addresses << Address.new(line1: 'somewhere', country: Country.new(name: 'UK'))
    assert_equal render_result, TemplateVersion.new(content: template_content).render(TemplateContext.new(user: user))
  end

  test "render with context with user with first_name and last_name" do
    template_content = "I am {{ user.first_name }} {{ user.last_name}} and my email is {{ user.email }}"
    render_result    = "I am John Smith and my email is j@s.c"
    user = User.new(email: 'j@s.c', first_name: 'John', last_name: 'Smith')
    assert_equal render_result, TemplateVersion.new(content: template_content).render(TemplateContext.new(user: user))
  end

  test 'language should be a symble' do
		assert_equal :en, TemplateVersion.new(content: 'This is a template',language: :en).language
	end

end
