# == Schema Information
#
# Table name: guards
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  class_name  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  method_name :string
#

class Guard < ApplicationRecord
  has_and_belongs_to_many :transitions
  validates :name, :class_name, :method_name, presence: true
  validates :method_name, uniqueness: { scope: :class_name }
  validate :dynamic_method_exists

  def check(workflow)
    self.class_name.constantize.send(self.method_name, workflow)
  end

  def dynamic_method_exists
    unless self.class_name.safe_constantize
      errors.add(:class_name, I18n.t('validations.invalid_class_name'))
      return
    end

    unless self.class_name.safe_constantize.methods.include?(self.method_name.to_sym)
      errors.add(:method_name, I18n.t('validations.invalid_method_name'))
      return
    end
  end
end
