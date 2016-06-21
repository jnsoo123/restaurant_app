class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :reject]

  skip_before_action :authenticate_user!, only: [:show]
  respond_to :html
  
  def index
  end

  def search
    @searchResult = []
    @searchResult << Cuisine.search_by_name(params[:searchQuery])
    @searchResult << Restaurant.search_by_name(params[:searchQuery])
    @searchResult << Food.search_by_name(params[:searchQuery])
    
    @searchQuery = params[:searchQuery]
    respond_with(@searchResult)
  end

  def show
  end
  
  def edit
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
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    @restaurant.save
    respond_with(@restaurant, location: users_dashboard_path)
  end
  
  def reject
  end
  
  def update
    if restaurant_params[:status] == 'rejected'
      Notification.create(user_id: @restaurant.user.id, message: params[:message])
      UserMailer.reject_email(@restaurant.user).deliver_now
    else
      Notification.create(user_id: @restaurant.user.id)
      UserMailer.accept_email(@restaurant.user).deliver_now
    end 
    
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
