# == Schema Information
#
# Table name: user_terms_of_services
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  terms_of_service_id :integer
#  approved            :boolean
#  approved_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class UserTermsOfService < ApplicationRecord
  belongs_to :user
  belongs_to :terms_of_service
end
