class UsersController < ApplicationController
  def disable_otp
    current_user.otp_required_for_login = false
    current_user.save!
    render users_tfa_path
  end

  def enable_otp
    current_user.otp_secret = User.generate_otp_secret
    current_user.otp_required_for_login = true
    current_user.save!
    render users_tfa_path
  end

  def tfa
  end
end
