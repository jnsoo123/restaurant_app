class FoodsController < ApplicationController
  before_action :set_food, only: [:edit, :update, :destroy]
  
  respond_to :html
  respond_to :js, only: [:new, :edit]
  
  def new
    @food = Food.new
    @food.restaurant = current_user.restaurants.find(params[:resto_id])
    respond_with(@food)
  end
  
  def edit
  end
  
  def update
    if @food.update(food_params)
      flash[:success] = "Dish successfully updated!"
      respond_with(@food, location: owner_resto_edit_path(@food.restaurant))
    else
      flash[:failure] = "<dl><dt>Your dish was not successfully updated because:</dt>" 
      @food.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@food.restaurant)
    end
  end
  
  def create
    @food = Food.new(food_params)
    @food.restaurant = current_user.restaurants.find(params[:resto_id])
    if @food.save
      flash[:success] = "Dish successfully added!"
      respond_with(@food, location: owner_resto_edit_path(params[:resto_id]))
    else
      flash[:failure] = "<dl><dt>Your dish was not successfully added because:</dt>" 
      @food.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(params[:resto_id])
    end
  end
  
  def destroy
    if @food.destroy
      flash[:success] = 'Dish successfully deleted!'
      respond_with(@food, location: owner_resto_edit_path(@food.restaurant))
    else
      flash[:failure] = "<dl><dt>Your dish was not successfully added because:</dt>" 
      @food.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@food.restaurant)
    end
  end
  
  private
  
  def set_food
    @food = Food.find(params[:id])  
  end
  
  def food_params
    params.require(:food).permit(:name, :description, :price, :cuisine_id)
  end
end