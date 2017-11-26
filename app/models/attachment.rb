class Attachment < ApplicationRecord
  belongs_to :workflow_transition
  validate :max_size

  MAX_SIZE = 500*1024

  def max_size
    errors.add(:content, I18n.t('validations.attachment_max_size')) if content && content.size > MAX_SIZE
  end
end
