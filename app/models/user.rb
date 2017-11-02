# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord

  # Configuration for TOTP
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['MAPPED_TOTP_ENCRYPTION_KEY']

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :registerable,
		   :recoverable, :rememberable, :trackable, :validatable,
		   :confirmable, :lockable

	has_many :user_roles
	has_many :roles, through: :user_roles

	def can?(action)
		raise "Unknown Action(#{action})" unless AccessRight.valid_action?(action)
		roles.joins(:access_rights).where(access_rights: {action: action}).size > 0
	end

	def context_value
		{ 'email' => email }
	end

end
