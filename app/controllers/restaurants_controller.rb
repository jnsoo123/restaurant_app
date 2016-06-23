class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :reject, :destroy]
  before_action :set_owner_restaurant, only: [:owner_edit, :owner_patch]
  skip_before_action :authenticate_user!, only: [:show, :search]
<<<<<<< HEAD
  
  layout 'owner', only: [:owner_edit, :owner_new]
  
=======
  before_action :authorize, only: [:listing, :reject, :edit]
>>>>>>> 63168a7d873a1e674102eeaa79657b73ec755a91
  respond_to :html
  
  def index
  end

  def search
#    @searchResult = []
#    @searchResult << Cuisine.where('name LIKE ?', "%#{params[:searchQuery]}%").foods
#    @searchResult << Cuisine.search_by_name(params[:searchQuery])
#    @searchResult << Restaurant.search_by_name(params[:searchQuery])
#    @searchResult << Food.search_by_name(params[:searchQuery])
    
#    @searchQuery = params[:searchQuery]
    respond_with(@searchResult)
  end

  def show
    @picture = Picture.new
    @rating = Rating.new
  end

  def owner_new
    @restaurant = Restaurant.new
    respond_with(@restaurant, template: 'users/owner/new')
  end
  
  def owner_edit
    @foods = @restaurant.foods
    @ratings = @restaurant.ratings
    @picture = Picture.new
    respond_with(@restaurant, template: 'users/owner/edit')
  end
  
  def edit
  end
  
  def listing
    @restos_accepted = Restaurant.where(status: "Accepted").order('updated_at DESC')
    @restos_rejected = Restaurant.where(status: "Rejected").order('updated_at DESC')
    @restos_pending = Restaurant.where(status: "Pending").order('updated_at DESC')
  end
  
  def new
    @restaurant = Restaurant.new
    respond_with(@restaurant)
  end
  
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    @restaurant.save
    respond_with(@restaurant, location: users_restaurant_path)
  end
  
  def reject
  end
  
  def update
    if current_user.admin
      if restaurant_params[:status] == 'Rejected'
        Notification.create(user_id: @restaurant.user.id, message: params[:message])
        UserMailer.reject_email(@restaurant.user).deliver_now
      elsif restaurant_params[:status] == 'Accepted'
        Notification.create(user_id: @restaurant.user.id)
        UserMailer.accept_email(@restaurant.user).deliver_now
      end 
      @restaurant.update(restaurant_params)
      respond_with(@restaurant, location: restaurant_listing_path)
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
    @restaurant.destroy
    flash[:success] = "#{name} has been deleted!"
    respond_with(@restaurant, location: users_restaurant_path)
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :map, :address, 
      :contact, :low_price_range, :high_price_range, :status, :cover, :avatar)
  end
  
  def set_owner_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  
  def set_owner_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end
  
end
