class TemplateContext
  include ActiveModel::Model
  attr_accessor :user, :organization, :campaign, :workflow, :access_request

  validate :validate_context

  def validate_context
    if user && !user.is_a?(User)
      errors[:user] << 'Invalid user'
      return
    end

    if organization && !organization.is_a?(Organization)
      errors[:organization] << 'Invalid organization'
      return
    end

    if campaign && !campaign.is_a?(Campaign)
      errors[:campaign] << 'Invalid campaign'
      return
    end

    if workflow && !workflow.is_a?(Workflow)
      errors[:workflow] << 'Invalid workflow'
      return
    end

    if access_request && !access_request.is_a?(AccessRequest)
      errors[:access_request] << 'Invalid access request'
      return
    end

  end

  def context_value
    result = {}
    result['user'] = user.context_value if user
    result['organization'] = organization.context_value if organization
    result['campaign'] = campaign.context_value if campaign
    result['workflow'] = workflow.context_value if workflow
    result['access_request'] = access_request.context_value if access_request
    result
  end

end
