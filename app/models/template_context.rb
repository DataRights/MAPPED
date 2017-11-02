class TemplateContext
  include ActiveModel::Model
  attr_accessor :user, :organization

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
  end

  def context_value
    result = {}
    result['user'] = user.context_value if user
    result['organization'] = organization.context_value if organization
    result
  end

end
