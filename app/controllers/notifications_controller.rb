class NotificationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @web_notifications = WebNotification.includes(:notification).joins(:notification).where(notifications: {user_id: current_user.id}).order(id: :desc)
    @web_notifications.where(status: :unread).update_all(status: :seen, seen_date: Time.now)
    begin
      @web_notifications.inspect
    rescue
      @web_notifications = []
    end

    WebNotification.update_unread_cache_by_user(current_user.id)
  end

  def settings
    @user = current_user
  end

  def update
    current_user.assign_attributes(user_params)
    if current_user.valid? && current_user.update(user_params)
      flash[:success] = I18n.t('notifications.settings.success')
    else
      flash[:alert] = current_user.errors.full_messages.join(". ")
    end

    redirect_to notifications_settings_path
  end

 private

  def user_params
    params.require(:user).permit(notification_setting_ids: [])
  end
end
