class UsersController < ApplicationController
  respond_to :html
  layout "owner", only: [:dashboard]
  before_action :set_user, only: [:show]
  
  def show
  end
  
  def dashboard
    respond_with(nil, template: 'users/owner/dashboard')
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end