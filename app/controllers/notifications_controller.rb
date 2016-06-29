class NotificationsController < ApplicationController
  before_action :set_user_notifications, only: :index
  before_action :set_notification, only: :destroy
  
  respond_to :html
  layout 'owner'
  
  def index
    @notifications.update_all(status: true)
    respond_with(@notifications, template: 'users/owner/notifications')
  end
  
  def destroy
    
  end
  
  private
  
  def set_user_notifications
    @notifications =  User.find(current_user.id).notifications.order('created_at desc')
  end
  
  def set_notification
    @notification = Notification.find(params[:id])
  end
end