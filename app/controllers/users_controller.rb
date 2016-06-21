class UsersController < ApplicationController
  respond_to :html
  layout "owner", only: [:restaurants]
  before_action :set_user, only: [:show]
  
  def show
  end
  
  def restaurants
    @restaurants = current_user.restaurants
    respond_with(@restaurants, template: 'users/owner/restaurants')
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end