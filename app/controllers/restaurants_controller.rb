class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show
  skip_before_action :authenticate_user!, only: [:show]
  
  respond_to :html
  
  def index
  end
  
  def show
  end
  
  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end
  
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    @restaurant.save
    respond_with(@restaurant, location: users_dashboard_path)
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :location, :contact, :address)
  end
  
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
