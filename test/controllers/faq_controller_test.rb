require 'test_helper'

class FaqControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "should get empty FAQ list" do
    sign_in users(:one)
    get faq_index_url
    assert_response :success
  end

  test "define an active template for FAQ and then test it" do
    sign_in users(:one)
    t = Template.new
    t.name = 'FAQ'
    t.template_type = :faq
    t.save!


    tv = TemplateVersion.new
    tv.template = t
    tv.version = 1.0
    tv.content = "<div id='container'>My Email address is {{ user.email }}</div>"
    tv.active = true
    tv.language = :en
    tv.save!

    get faq_index_url
    assert_response :success
    assert response.body.include?("<div id='container'>My Email address is #{users(:one).email}</div>"), response.body
  end
end
