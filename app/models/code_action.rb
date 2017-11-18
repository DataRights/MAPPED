# == Schema Information
#
# Table name: code_actions
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :string
#  class_name    :string
#  method_name   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  internal_data :jsonb
#

class CodeAction < ApplicationRecord
  has_and_belongs_to_many :transitions
  validates :name, :class_name, :method_name, presence: true
  validates :method_name, uniqueness: { scope: :class_name }
  validate :check_class_method_params?

  def execute(workflow)
    if internal_data
      self.class_name.constantize.send(self.method_name, workflow, internal_data)
    else
      self.class_name.constantize.send(self.method_name, workflow)
    end
  end

  def rollback(workflow)
    rollback_method_name = "#{self.method_name}_rollback"
    if self.class_name.constantize.methods.include?(rollback_method_name.to_sym)
      self.class_name.constantize.send(rollback_method_name, workflow)
    else
      { result: false, message: I18n.t('rollback_method_does_not_exist_for_action')}
    end
  end

  def check_class_method_params?
    unless self.class_name.safe_constantize
      errors.add(:class_name, I18n.t('validations.invalid_class_name'))
      return
    end

    unless self.class_name.safe_constantize.methods.include?(self.method_name.to_sym)
      errors.add(:method_name, I18n.t('validations.invalid_method_name'))
      return
    end

    m = self.class_name.safe_constantize.method(self.method_name.to_sym)
    if m.parameters.include?([:req, :internal_data]) and self.internal_data.blank?
      errors.add(:internal_data, I18n.t('validations.action_internal_data_required'))
      return
    end
  end
end
