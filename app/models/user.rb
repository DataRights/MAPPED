# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  failed_attempts           :integer          default(0), not null
#  unlock_token              :string
#  locked_at                 :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  unconfirmed_email         :string
#  encrypted_otp_secret      :string
#  encrypted_otp_secret_iv   :string
#  encrypted_otp_secret_salt :string
#  consumed_timestep         :integer
#  otp_required_for_login    :boolean
#  first_name                :string
#  last_name                 :string
#  preferred_language        :string
#  custom_1                  :text
#  custom_2                  :text
#  custom_3                  :text
#  notification_type         :integer          default("email_realtime")
#

class User < ApplicationRecord

  enum notification_type: [:no_email, :email_realtime, :email_daily_digest, :email_weekly_digest]

  # Configuration for TOTP
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['MAPPED_TOTP_ENCRYPTION_KEY']

  attribute :otp_secret

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :registerable,
		   :recoverable, :rememberable, :trackable, :validatable,
		   :confirmable, :lockable

	has_many :user_roles
	has_many :roles, through: :user_roles
  has_many :addresses, as: :addressable
  has_many :answers, as: :answerable
  has_many :notifications


	def can?(action)
		raise "Unknown Action(#{action})" unless AccessRight.valid_action?(action)
		roles.joins(:access_rights).where(access_rights: {action: action}).size > 0
	end

	def context_value
		result = { 'email' => email }
    result['addresses'] = addresses.map(&:context_value) unless addresses.blank?
    result['first_name'] = first_name if first_name
    result['last_name'] = last_name if last_name
    result['custom_1'] = custom_1 if custom_1
    result['custom_2'] = custom_2 if custom_2
    result['custom_3'] = custom_3 if custom_3
    result
	end

  def preferred_language
    self.attributes['preferred_language'].try(:to_sym)
  end

  def enable_otp!
    self.otp_secret = User.generate_otp_secret
    self.otp_required_for_login = true
    self.save!
  end

  def disable_otp!
    self.otp_required_for_login = false
    self.save!
  end
end
