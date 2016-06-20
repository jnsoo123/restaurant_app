class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_restaurant, only: [:update]
  respond_to :html
  
  def index
  end
  
  def show
  end
  
  def listing
    @restos_accepted = Restaurant.where(status: "accepted").order('updated_at DESC')
    @restos_rejected = Restaurant.where(status: "rejected").order('updated_at DESC')
    @restos_ongoing = Restaurant.where(status: "ongoing").order('updated_at DESC')
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
  
  def update
    @restaurant.update(restaurant_params)
    respond_with(@restaurant, location: restaurant_listing_path)
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :location, :contact, :address)
    params.require(:restaurant).permit(:name, :description, :map, :address, 
                                      :contact, :low_price_range, :high_price_range, :status)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  
end
