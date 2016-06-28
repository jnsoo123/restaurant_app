class RatingsController < ApplicationController
  
  respond_to :html
  before_action :authorize, only: [:index]
  
  def index
    @order = ["DESC","ASC","ASC"] if @order.nil?
    if(params[:search_category].nil?)
      @ratings = Rating.order('rate DESC')
    else      
      @ratings, @order = Rating.sort(params[:search_category], params[:search_order]) 
    end
  end
  
  def create
    @rating = Rating.new(rate_params)
    @rating.user = current_user
    if @rating.save 
      flash[:success] = "You have successfully rated the restaurant"
      respond_with(@rating, location: @rating.restaurant)
    else
      flash[:failure] = "Your rating was not saved properly"
      respond_with(@rating, location: @rating.restaurant)
    end
  end
  
  private
  
  def rate_params
    params.require(:rating).permit(:rate, :comment, :restaurant_id)
  end
end