require 'test_helper'

class TemplateContextTest < ActiveSupport::TestCase
	test 'user should be a valid User or nil' do
		context = TemplateContext.new
		assert context.valid?

		context.user = 1
		assert_not context.valid?
		assert_includes context.errors[:user], 'Invalid user'

		context.user = users(:three)
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

	test 'campaign should be a valid Campaign or nil' do
		context = TemplateContext.new
		assert context.valid?

		context.campaign = 1
		assert_not context.valid?
		assert_includes context.errors[:campaign], 'Invalid campaign'

		context.campaign = Campaign.new(name: 'campaign1')
		assert context.valid?
	end

	test 'access_request should be a valid access_request or nil' do
		context = TemplateContext.new
		assert context.valid?

		context.access_request = 1
		assert_not context.valid?
		assert_includes context.errors[:access_request], 'Invalid access request'

		context.access_request = access_requests(:one)
		assert context.valid?
	end

	test 'workflow should be a valid workflow or nil' do
		context = TemplateContext.new
		assert context.valid?

		context.workflow = 1
		assert_not context.valid?
		assert_includes context.errors[:workflow], 'Invalid workflow'

		context.workflow = workflows(:one)
		assert context.valid?
	end

	test "the context_value" do
    assert_equal ({}), TemplateContext.new().context_value
		assert_equal ({'user' => {'email' => 'test@test.com'}}), TemplateContext.new(user: User.new(email: 'test@test.com')).context_value
		assert_equal ({'organization' => {'name' => 'hosp1'}}), TemplateContext.new(organization: Organization.new(name: 'hosp1')).context_value
		assert_equal ({'campaign' => {'name' => 'campaign1'}}), TemplateContext.new(campaign: Campaign.new(name: 'campaign1')).context_value
  end

end
