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
#  workflow_transition_id :integer
#

class Attachment < ApplicationRecord
  belongs_to :workflow_transition
  has_many :tags, :as => :tagable, dependent: :destroy
  has_many :comments, :as => :commentable, dependent: :destroy
  validate :max_size

  MAX_SIZE = 500*1024

  def max_size
    errors.add(:content, I18n.t('validations.attachment_max_size')) if content && content.size > MAX_SIZE
  end
end
