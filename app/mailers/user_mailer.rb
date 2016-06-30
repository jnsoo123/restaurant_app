class UserMailer < ActionMailer::Base
  default from: 'restaurant@notifications.com'

  def send_email(user)
    @user = user
    @restaurant = Restaurant.where(user_id: user.id).last
    @notification = Notification.where(user_id: user.id).order('created_at').last
    mail(to: @user.email, subject: 'Restaurant Establishment Application')
  end
  
  def notify_email(user)
    @user = user
    puts "THIS IS @user: #{@user.inspect}\n\n\n"
    mail(to: @user.email, subject: 'Notification Updates')
  end
  
  # def notify_email(user)
  #   @user = user
  #   mail(to: @user.email, subject: 'Fudz Finder Message Update')
  # end
  #
end