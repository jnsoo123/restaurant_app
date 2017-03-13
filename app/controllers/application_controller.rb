class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: [:change_locale, :set_locale]
  before_action :set_locale
  add_flash_types :success, :failure

  rescue_from ActiveRecord::RecordNotFound, with: :raise_not_found
  rescue_from SecurityError, with: :not_found
  rescue_from RuntimeError, with: :show_error

  include DeviseHelper
  helper ApplicationHelper

  def raise_not_found
    render template: 'errors/404', :layout => false, status: 404
  end

  def change_locale
      l = params[:locale].to_s.strip.to_sym
      l = I18n.default_locale unless I18n.available_locales.include?(l)
      cookies.permanent[:educator_locale] = l
      redirect_to request.referer || root_url
  end

  def authorize
    if user_signed_in?
      unless current_user.admin?
        redirect_to home_path
      end
    end
  end

  def authenticate_admin_user!
    raise SecurityError unless current_user.try(:admin?)
  end

  private

  def not_found
    render :template => "errors/404", :layout => false, :status => 404
  end

  def show_error
    flash[:notice] = "Cant delete last admin"
    redirect_to user_path(current_user)
  end

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :username, :location])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :username, :location, :profile_picture_url, :avatar])
  end
#
#  def after_sign_in_path_for(resource_or_scope)
#    if current_user.admin?
#      administrator_path
#    else
#      home_path
#    end
#  end
end
