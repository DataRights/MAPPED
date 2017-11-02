require 'test_helper'

class TemplateContextTest < ActiveSupport::TestCase
	test 'user should be a valid User or nil' do
		context = TemplateContext.new
		assert context.valid?

		context.user = 1
		assert_not context.valid?
		assert_includes context.errors[:user], 'Invalid user'

		context.user = users(:test_user)
		assert context.valid?
	end

	test 'organization should be a valid Organization or nil' do
		context = TemplateContext.new
		assert context.valid?

		context.organization = 1
		assert_not context.valid?
		assert_includes context.errors[:organization], 'Invalid organization'

		context.organization = organizations(:hospital1)
		assert context.valid?
	end

	test "the context_value" do
    assert_equal ({}), TemplateContext.new().context_value
		assert_equal ({'user' => {'email' => 'test@test.com'}}), TemplateContext.new(user: User.new(email: 'test@test.com')).context_value
		assert_equal ({'organization' => {'name' => 'hosp1'}}), TemplateContext.new(organization: Organization.new(name: 'hosp1')).context_value
  end

end
