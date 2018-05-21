# == Schema Information
#
# Table name: attachments
#
#  id                     :integer          not null, primary key
#  title                  :string
#  content_type           :string
#  content                :binary
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  access_request_step_id :integer
#  response_id            :integer
#

# response category: post, email, ..., ?

class Attachment < ApplicationRecord
  belongs_to :access_request_step, optional: true
  belongs_to :response, optional: true
  #HA has_many :tags, :as => :tagable, dependent: :destroy
  #has_many :comments, :as => :commentable, dependent: :destroy
  validate :max_size, if: :content

  # validates :content_type, inclusion: { in: %w(application/pdf image/jpeg image/png application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document text/plain),
  #   message: I18n.t('validations.attachment_content_type') }, if: :content

  MAX_SIZE = 5048*1024

  def max_size
    errors.add(:content, I18n.t('validations.attachment_max_size')) if content.size > MAX_SIZE
  end
end
