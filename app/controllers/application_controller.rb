class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  add_flash_types :success

  def change_locale  
      l = params[:locale].to_s.strip.to_sym
      l = I18n.default_locale unless I18n.available_locales.include?(l)
      cookies.permanent[:educator_locale] = l
      redirect_to request.referer || root_url
  end

  private
  
  def set_locale
    if cookies[:educator_locale] && I18n.available_locales.include?(cookies[:educator_locale].to_sym)
      l = cookies[:educator_locale].to_sym
    else
      l = I18n.default_locale
      cookies.permanent[:educator_locale] = l
    end
    I18n.locale = l
  end
  
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
