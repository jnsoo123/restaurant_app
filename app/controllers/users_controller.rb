class UsersController < ApplicationController
  respond_to :html
  layout "owner", only: [:restaurants]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize, only: [:edit, :update]
  before_action :authorize_owner, only: [:restaurants]
  skip_before_action :authenticate_user!, only: :show
  
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
    respond_with(@user, location: administrator_path)
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :username, :email, :location, :profile_picture_url)
  end
  
  def authorize_owner
    if current_user.restaurants.blank?
      flash[:failure] = t('.noresto')
      redirect_to home_path
    end
  end
end