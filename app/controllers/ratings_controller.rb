class RatingsController < ApplicationController
  
  respond_to :html
  respond_to :js, only: [:edit, :show_more, :more_reviews]
  before_action :set_rating, only: [:edit, :update]
  before_action :authorize, only: [:index]
  skip_before_action :authenticate_user!, only: :show_more
  
  def index
    
  end
  
  def show_more
    @all = params[:more] || nil
    @review_id = params[:rate_id]
    @more_reviews = params[:review]
    puts "############ #{@all}"
    @restaurant = Restaurant.find(params[:id]) unless params[:user].present?
    @user = User.find(params[:id]) if params[:user].present?
    respond_with(@all)
  end
  
  def more_reviews
    @more_reviews = params[:more]
    @restaurant = Restaurant.find(params[:id]) unless params[:user].present?
    respond_with(@all)
  end
  
  def create
    @rating = Rating.new(rate_params)
    @rating.user = current_user
    if @rating.save 
      flash[:success] = t('.success')
      Notification.create(message: "#{view_context.link_to current_user.name, user_path(current_user)} rated on your restaurant #{view_context.link_to @rating.restaurant.name, restaurant_path(@rating.restaurant)} with a #{@rating.rate} star rating.", user: @rating.restaurant.user)
      respond_with(@rating, location: @rating.restaurant)
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
      @rating.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to restaurant_path(@rating.restaurant)
    end
  end
  
  def update
    if @rating.update(rate_params)
      flash[:success] = t('.success')
      respond_with(@rating, location: restaurant_path(@rating.restaurant))
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
      @rating.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to restaurant_path(@rating.restaurant)
    end
  end
  
  def edit
  end
  
  private
  
  def rate_params
    params.require(:rating).permit(:rate, :comment, :restaurant_id)
  end
  
  def set_rating
    @rating = Rating.find(params[:id])
  end
end