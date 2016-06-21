class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_owner_restaurant, only: [:owner_edit, :owner_patch]
  before_action :set_restaurant, only: [:show, :edit, :update, :reject, :update, :destroy]
  layout 'owner', only: [:owner_edit, :owner_new]
  
  respond_to :html
  
  def index
  end
  
  def show
  end
  
  def owner_edit
    @foods = @restaurant.foods
    respond_with(@restaurant, template: 'users/owner/edit')
  end
  
  def owner_new
    @restaurant = Restaurant.new
    respond_with(@restaurant, template: 'users/owner/new')
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
    flash[:success] = "Restaurant has been registered! Wait for the confirmation of the admin via email or notification here."
    respond_with(@restaurant, location: users_restaurant_path)
  end
  
  def reject
  end
  
  def update
    if current_user.admin
      if restaurant_params[:status] == 'rejected'
        Notification.create(user_id: @restaurant.user.id, message: params[:message])
        UserMailer.reject_email(@restaurant.user).deliver_now
      else
        Notification.create(user_id: @restaurant.user.id)
        UserMailer.accept_email(@restaurant.user).deliver_now
      end 
      @restaurant.update(restaurant_params)
    else
      @restaurant.update(restaurant_params)
      if params[:path] == 'dashboard'
        flash[:success] = "<strong>#{@restaurant.name}</strong> has been successfully updated!"
        respond_with(@restaurant, location: owner_resto_edit_path(@restaurant))
      else
        respond_with(@restaurant, location: restaurant_listing_path)
      end
    end
      
    
    
    
  end
  
  def destroy
    name = @restaurant.name
    @restaurant.destroy
    flash[:success] = "#{name} has been deleted!"
    respond_with(@restaurant, location: users_restaurant_path)
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :map, :address, 
                                      :contact, :low_price_range, :high_price_range, :status)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  
  def set_owner_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end
  
  
end
