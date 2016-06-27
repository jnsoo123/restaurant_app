class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :reject, :destroy]
  before_action :set_owner_restaurant, only: [:owner_edit, :owner_patch]
  skip_before_action :authenticate_user!, only: [:show, :search]
  
  layout 'owner', only: [:owner_edit, :owner_new]
  before_action :authorize, only: [:listing, :reject, :edit]
  respond_to :html
  
  def index
  end

  def search
    @search_result = []
    sort_type = params[:sort]
    sort_type ||= 'ratings'
    if params[:cuisine].blank?
      @search_result << Cuisine.search_by_name(params[:searchQuery])
      @search_result << Restaurant.search_by_name(params[:searchQuery])
      @search_result << Food.search_by_name(params[:searchQuery])
    else
      @search_result << Cuisine.find(params[:cuisine]).foods.where("name LIKE ?", "%#{params[:searchQuery]}%").map {|food| food.restaurant.id }
    end 
    @search_result.flatten!(1)
    
    unless params[:price_range].nil?
      @search_range = params[:price_range].split(',')
      @result = Restaurant.find(@search_result).map {|restaurant| restaurant.foods.map {|food| food.restaurant if food.price.between?(@search_range[0].to_i,@search_range[1].to_i)} }.flatten(1).compact
      @search_result = Restaurant.find(@result)
    end
    
    if sort_type == 'ratings'
      @result = Restaurant.includes(:ratings).order('ratings.rate desc').find(@search_result)
    elsif sort_type == 'name'
      @result = Restaurant.order('name').find(@search_result)
    elsif sort_type == 'price_low_to_high'
      @result = Restaurant.includes(:foods).order('foods.price').find(@search_result)
    else
      @result = Restaurant.includes(:foods).order('foods.price desc').find(@search_result)
    end
    puts "@@@@@@@@@@@@#{@result}"
    puts "@@@@@@@@@@@@#{@search_result}"
    @searchQuery = params[:searchQuery]
    @price_range = params[:price_range] unless params[:price_range].nil?
    respond_with(@result)
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
