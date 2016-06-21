class UsersController < ApplicationController
  respond_to :html
  layout "owner", only: [:restaurants]
  before_action :set_user, only: [:show, :edit, :update]
  
  def show
  end
  
  def restaurants
    @restaurants = current_user.restaurants
    respond_with(@restaurants, template: 'users/owner/restaurants')
  end

  def edit
    respond_with(@user, template: 'users/admin/edit')
  end
  
  def update
    @user.update(user_params)
    redirect_to administrator_path
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :username, :email, :location, :profile_picture_url)
  end
end