class RestaurantsController < ApplicationController
  respond_to :html
  
  def index
  end
  
  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end
  
  def create
  end
end
