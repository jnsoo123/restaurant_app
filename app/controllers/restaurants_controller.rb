class RestaurantsController < ApplicationController
  
  respond_to :html
  
  def index
  end
  
  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end
  
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.save
    respond_with(@restaurant, location: users_dashboard_path)
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :location, :contact)
  end
end
