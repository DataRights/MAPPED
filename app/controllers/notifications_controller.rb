class NotificationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @web_notifications = WebNotification.joins(:notification).where(notifications: {user_id: current_user.id})
  end
end
