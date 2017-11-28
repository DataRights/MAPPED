class UsersController < ApplicationController
  def disable_otp
    current_user.disable_otp!
    render users_tfa_path
  end

  def enable_otp
    current_user.enable_otp!
    render users_tfa_path
  end

  def tfa
  end

  def edit
    @user = current_user
  end

  def update
  end
end
