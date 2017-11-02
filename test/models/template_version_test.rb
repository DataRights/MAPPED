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

  test "render with context" do
    template_content = "This is a template with context\n {{ user.email }}\n Sending access request to {{ organization.name }} "
    render_result    = "This is a template with context\n test123@test.com\n Sending access request to Schiphol Airport "
    assert_equal render_result, TemplateVersion.new(content: template_content).render(TemplateContext.new(user: User.new(email: 'test123@test.com'), organization: Organization.new(name: 'Schiphol Airport')))
  end
end
