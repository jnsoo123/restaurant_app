class NotificationsController < ApplicationController
  before_action :set_user_notifications, only: :index
  before_action :set_notification, only: :destroy
  
  respond_to :html
  respond_to :js, only: :destroy
  layout 'owner'
  
  def index
    @notifications.update_all(status: true)
    @notifications = @notifications.page params[:page]
    respond_with(@notifications, template: 'users/owner/notifications')
  end
  
  def destroy
    @notification.destroy
    flash[:success] = t('.success')
    respond_with(@notification)
  end
  
  private
  
  def set_user_notifications
    @notifications =  User.find(current_user.id).notifications.order('created_at desc')
  end
  
  def set_notification
    @notification = Notification.find(params[:id])
  end
end