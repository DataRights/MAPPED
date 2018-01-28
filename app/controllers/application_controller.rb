class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :get_campaigns
  before_action :get_count_of_unread_notifications
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  def get_campaigns
    @campaigns = Campaign.top_three
  end

  def get_count_of_unread_notifications
    if current_user
      @unread_notifications_count = WebNotification.unread_web_notifications(current_user.id)
    end
  end

  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
    cookies[:locale] = I18n.locale
  end

end
