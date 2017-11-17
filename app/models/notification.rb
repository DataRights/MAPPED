# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  access_request_id :integer
#  title             :string
#  content           :string
#  status            :integer          default("pending")
#  seen_date         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :access_request, optional: true
  enum status: [:pending, :email_sent, :seen]
end
