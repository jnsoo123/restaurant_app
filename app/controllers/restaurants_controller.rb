class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :reject]
  before_action :set_pending_restaurant, only: [:destroy, :update]
  before_action :set_owner_restaurant, only: [:owner_edit, :owner_patch]
  skip_before_action :authenticate_user!, only: [:show, :search]
  layout 'owner', only: [:owner_edit, :owner_new]
  before_action :authorize, only: [:listing, :reject, :edit]
  respond_to :html

  

  def search
    @search_result = []
    @main_active = false
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
    
    puts "@@@@@@@@ #{@search_result}"
    
    if params[:location].present?
      if sort_type == 'ratings'
        @result = Restaurant.where(id: Location.find(params[:location]).nearbys(3).map(&:restaurant_id) & @search_result.map(&:id), status: 'Accepted').joins("LEFT JOIN ratings ON ratings.restaurant_id = restaurants.id").group("restaurants.id").order("AVG(ratings.rate) DESC")
        puts "@@@@ DUMAAN DITO GUYS"
        puts "@@@@ #{@search_result}"
      elsif sort_type == 'name'
        @result = Restaurant.where(id: Location.find(params[:location]).nearbys(3).map(&:restaurant_id) & @search_result.map(&:id), status: 'Accepted').order('name')
      elsif sort_type == 'price_low_to_high'
        @result = Restaurant.where(id: Location.find(params[:location]).nearbys(3).map(&:restaurant_id) & @search_result.map(&:id), status: 'Accepted').includes(:foods).order('foods.price')
      else
        @result = Restaurant.where(id: Location.find(params[:location]).nearbys(3).map(&:restaurant_id) & @search_result.map(&:id), status: 'Accepted').includes(:foods).order('foods.price desc')
      end
    else
      if sort_type == 'ratings'
        @result = Restaurant.where(id: @search_result, status: 'Accepted').joins("LEFT JOIN ratings ON ratings.restaurant_id = restaurants.id").group("restaurants.id").order("AVG(ratings.rate) DESC")
      elsif sort_type == 'name'
        @result = Restaurant.order('name').where(id: @search_result, status: 'Accepted')
      elsif sort_type == 'price_low_to_high'
        @result = Restaurant.includes(:foods).order('foods.price').where(id: @search_result, status: 'Accepted')
      else
        @result = Restaurant.includes(:foods).order('foods.price desc').where(id: @search_result, status: 'Accepted')
      end
    end
    
    
    @searchQuery = params[:searchQuery] || ""
    @price_range = params[:price_range] unless params[:price_range].nil?
    @location = Location.find(params[:location]).id if params[:location].present?
    @cuisine = Cuisine.find(params[:cuisine]).id if params[:cuisine].present?
    @main_active = true if sort_type == 'ratings'
    
    unless @result.kind_of?(Array)
      @result = @result.page(params[:page])
    else
      @result = Kaminari.paginate_array(@result).page(params[:page])
    end
#    @result = @result.page(params[:page])
    respond_with(@result)
  end

  def show
    if @restaurant.blank?
      render template: 'errors/404', :layout => false, status: 404
    else
      @picture = Picture.new
      @rating = Rating.new
    end
  end

  def owner_new
    @restaurant = Restaurant.new
    respond_with(@restaurant, template: 'users/owner/new')
  end
  
  def owner_edit
    @foods = @restaurant.foods.order(created_at: :desc)
    @ratings = @restaurant.ratings(created_at: :desc)
    @schedules = @restaurant.schedules
    @posts = @restaurant.posts(created_at: :desc)
    @pictures = @restaurant.pictures.order('created_at desc')
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
    name = @restaurant.name
    
    if @restaurant.save
      if params[:latitude].present? 
        Location.create(latitude: params[:latitude], longitude: params[:longitude], restaurant: @restaurant)
        if @restaurant.address.blank?
          @restaurant.update(address: @restaurant.location.address)
        end
      end
      flash[:success] = t('.success')
      respond_with(@restaurant, location: users_restaurant_path)
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
      @restaurant.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      respond_with(@restaurant, location: owner_resto_new_path)
    end
  end
  
  def reject
  end
  
  def update    
#    raise
    if @restaurant.update(restaurant_params)
      if @restaurant.location.present?
        if params[:latitude].present?
          old_address = @restaurant.location.address
          @restaurant.location.update(latitude: params[:latitude], longitude: params[:longitude])
          if @restaurant.address == old_address || @restaurant.address.blank?
            @restaurant.update(address: @restaurant.location.address)
          end
        end
      else
        if params[:latitude].present?
          puts "@@@@@@@@@ #{params[:latitude]}"
          location = Location.create(latitude: params[:latitude], longitude: params[:longitude], restaurant_id: @restaurant.id)
        end
      end
      flash[:success] = t('.success')
      respond_with(@restaurant, location: owner_resto_edit_path(@restaurant))
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>"
      @restaurant.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@restaurant)
    end
  end
  
  def destroy
    name = @restaurant.name
    if @restaurant.destroy
      flash[:success] = t('.success')
      respond_with(@restaurant, location: users_restaurant_path)
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
      @restaurant.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@restaurant) 
    end
  end
  
  private
  
  def restaurant_params
    params.require(:restaurant).permit(:name, :map, :address, 
      :contact, :website, :status, :cover, :avatar)
  end
    
  def set_owner_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end
  
  
  def set_pending_restaurant
    @restaurant = Restaurant.find_by_id(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.where(status: 'Accepted').find_by_id(params[:id])
  end
  
  def set_owner_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end
  
end
