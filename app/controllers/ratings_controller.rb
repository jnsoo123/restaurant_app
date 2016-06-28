class RatingsController < ApplicationController
  
  respond_to :html
  respond_to :js, only: :edit
  before_action :set_rating, only: [:edit, :update]
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
      flash[:failure] = "<dl><dt>Your rating was not saved properly because:</dt>" 
      @rating.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to restaurant_path(@rating.restaurant)
    end
  end
  
  def update
    if @rating.update(rate_params)
      flash[:success] = "You have successfully updated your rating"
      respond_with(@rating, location: restaurant_path(@rating.restaurant))
    else
      flash[:failure] = "<dl><dt>Your rating was not updated properly because:</dt>" 
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