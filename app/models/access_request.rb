# == Schema Information
#
# Table name: access_requests
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  user_id            :integer
#  meta_data          :jsonb
#  sent_date          :datetime
#  data_received_date :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  campaign_id        :integer
#

class AccessRequest < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :campaign
  has_many :attachments
end
