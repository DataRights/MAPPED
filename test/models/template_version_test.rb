require 'test_helper'

class TemplateVersionTest < ActiveSupport::TestCase
  test "render" do
    assert_equal '', TemplateVersion.new.render(nil)

    exception = assert_raise (RuntimeError ) {TemplateVersion.new(content: 'This is a template').render(nil)}
    assert_equal 'Invalid context', exception.message

    exception = assert_raise (RuntimeError ) {TemplateVersion.new(content: 'This is a template').render('wrong context')}
    assert_equal 'Wrong context type', exception.message

    assert_equal 'This is a template', TemplateVersion.new(content: 'This is a template').render(TemplateContext.new)
  end
end
