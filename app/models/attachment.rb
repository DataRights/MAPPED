# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  title           :string
#  content_type    :string
#  content         :binary
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_type :string
#  attachable_id   :integer
#  user_id         :integer
#  private_content :boolean          default(FALSE)
#

# response category: post, email, ..., ?

class Attachment < ApplicationRecord

  belongs_to :attachable, :polymorphic => true, optional: true
  belongs_to :user, optional: true

  has_many :comments, :as => :commentable, dependent: :destroy
  validate :max_size, if: :content
  validates_presence_of :content
  validate :remarks_when_private

  def remarks_when_private
    errors.add(:private_content, I18n.t('validations.remarks_when_private')) if private_content && attachable.access_request_step.remarks.blank?
  end

  # validates :content_type, inclusion: { in: %w(application/pdf image/jpeg image/png application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document text/plain),
  #   message: I18n.t('validations.attachment_content_type') }, if: :content

  MAX_SIZE = 5048*1024

  def max_size
    errors.add(:content, I18n.t('validations.attachment_max_size')) if content.size > MAX_SIZE
  end
end
