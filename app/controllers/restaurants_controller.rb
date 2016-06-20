class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:update, :reject]
  respond_to :html
  
  def index
  end
  
  def listing
    @restos_accepted = Restaurant.where(status: "accepted").order('updated_at DESC')
    @restos_rejected = Restaurant.where(status: "rejected").order('updated_at DESC')
    @restos_pending = Restaurant.where(status: "pending").order('updated_at DESC')
  end
  
  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end
  
  def create
    restaurant_params[:user_id] = current_user.id

    @restaurant = Restaurant.new(hash_values)
    @restaurant.save
    respond_with(@restaurant, location: users_dashboard_path)
  end
  
  def reject
  end
  
  def update
    UserMailer.reject_email(@restaurant.user).deliver_now if restaurant_params[:status] == 'rejected'
   
    @restaurant.update(restaurant_params)
    respond_with(@restaurant, location: restaurant_listing_path)
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :map, :address, 
                                      :contact, :low_price_range, :high_price_range, :status)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  
end
