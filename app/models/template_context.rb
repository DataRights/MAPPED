class TemplateContext
  include ActiveModel::Model
  attr_accessor :user, :organization, :campaign

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

  end

  def context_value
    result = {}
    result['user'] = user.context_value if user
    result['organization'] = organization.context_value if organization
    result['campaign'] = campaign.context_value if campaign
    result
  end

end
