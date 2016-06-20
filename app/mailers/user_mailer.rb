class UserMailer < ActionMailer::Base
  default from: 'restaurant@notifications.com'
 
  def reject_email(user)
      @user = user
      @restaurant = Restaurant.where(user_id: user.id).last
      @notification = Notification.where(user_id: user.id).order('created_at').last
      mail(to: @user.email, subject: 'Restaurant Establishment Application')
  end
 
end