require 'test_helper'

class TemplateVersionTest < ActiveSupport::TestCase
  test "render" do
    assert_equal '', TemplateVersion.new.render(nil)
  end
end
