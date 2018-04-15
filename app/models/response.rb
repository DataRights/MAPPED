# == Schema Information
#
# Table name: responses
#
#  id                :integer          not null, primary key
#  response_type_id  :integer
#  description       :text
#  received_date     :datetime
#  access_request_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Response < ApplicationRecord
  belongs_to :response_type
  belongs_to :access_request
  has_many :attachments
end
