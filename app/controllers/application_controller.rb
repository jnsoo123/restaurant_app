class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  
  private
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :email, :username, :location]
    devise_parameter_sanitizer.for(:account_update) << [:name, :email, :username, :location, :profile_picture_url]
  end
  
  def after_sign_in_path_for(resource_or_scope)
    if current_user.admin?
      administrator_path
    else
      home_path
    end
  end
end
