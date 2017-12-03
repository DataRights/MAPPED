# == Schema Information
#
# Table name: user_policy_consents
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  policy_consent_id :integer
#  approved          :boolean
#  approved_date     :datetime
#  revoked_date      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class UserPolicyConsent < ApplicationRecord
  belongs_to :user
  belongs_to :policy_consent

  before_save :set_dates, if: :approved_changed?

  def set_dates
    if self.approved
      self.approved_date = Time.now
    else
      self.revoked_date = Time.now
    end
  end
end
