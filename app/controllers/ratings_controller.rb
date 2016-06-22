class RatingsController < ApplicationController
  
  respond_to :html
  
  def index
    if(params[:search_category].nil?)
      @ratings = Rating.order('rate DESC')
    else
      @ratings = Rating.sort(params[:search_category])
    end
  end
  
  def create
    @rating = Rating.new(rate_params)
    @rating.user = current_user
    @rating.save
    respond_with(@rating, location: @rating.restaurant)
  end
  
  private
  
  def rate_params
    params.require(:rating).permit(:rate, :comment, :restaurant_id)
  end
end