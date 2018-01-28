class NotificationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @web_notifications = WebNotification.includes(:notification).joins(:notification).where(notifications: {user_id: current_user.id}).order(id: :desc)
    @web_notifications.where(status: :unread).update_all(status: :seen, seen_date: Time.now)
    WebNotification.update_unread_cache_by_user(current_user.id)
  end
end
