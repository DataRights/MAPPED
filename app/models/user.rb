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
#  invitation_token          :string
#  invitation_created_at     :datetime
#  invitation_sent_at        :datetime
#  invitation_accepted_at    :datetime
#  invitation_limit          :integer
#  invited_by_type           :string
#  invited_by_id             :integer
#  invitations_count         :integer          default(0)
#  approved                  :boolean          default(FALSE), not null
#

class User < ApplicationRecord

  # Configuration for TOTP
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['MAPPED_TOTP_ENCRYPTION_KEY']

  attribute :otp_secret

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :invitable, :registerable,
		   :recoverable, :rememberable, :trackable, :validatable,
		   :confirmable, :lockable, :async

	has_many :user_roles, :dependent => :destroy
	has_many :roles, through: :user_roles, :dependent => :destroy
  has_one :address, as: :addressable, :dependent => :destroy, :inverse_of => :addressable
  has_many :answers, as: :answerable, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_and_belongs_to_many :notification_settings, :dependent => :destroy
  has_and_belongs_to_many :campaigns, :dependent => :destroy
  has_many :tags, :as => :tagable, :dependent => :destroy
  has_many :comments, dependent: :destroy
  has_many :user_policy_consents, dependent: :destroy
  has_many :access_requests, dependent: :destroy
  has_many :organizations, foreign_key: 'suggested_by_user_id', dependent: :nullify

  before_create :add_default_notification_settings
  after_create :check_approved

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :user_policy_consents

  attr_accessor :campaign_id

  def add_default_notification_settings
    if notification_settings.nil? or notification_settings.count == 0
      notification_settings << NotificationSetting.find_by(notification_type: 'web_notification')
    end
    true
  end

	def can?(action)
		raise "Unknown Action(#{action})" unless AccessRight.valid_action?(action)
		roles.joins(:access_rights).where(access_rights: {action: action}).size > 0
	end

	def context_value
		result = { 'email' => email }
    result['address'] = address.context_value if address
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

  def full_name
    if self.first_name or self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      self.email
    end
  end

  def check_approved
    s = Setting.find_by key: 'auto_approved_user_domains'
    return true unless s

    whitelist_domains = s.value.split(',')
    whitelist_domains.each do |domain|
      if domain == '*' || email.downcase.end_with?(domain.strip.downcase)
        self.update_attribute(:approved, true)
      end
    end
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end
end
