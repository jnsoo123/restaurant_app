class UserMailer < ActionMailer::Base
  default from: 'restaurant@notifications.com'
 
  def reject_email(user)
      @user = user
      @restaurant = Restaurant.where(user_id: user.id).last
      mail(to: @user.email, subject: 'Restaurant Establishment Application')
  end
 
end