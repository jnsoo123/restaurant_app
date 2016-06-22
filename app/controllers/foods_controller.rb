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
    @food.update(food_params)
    respond_with(@food, location: owner_resto_edit_path(@food.restaurant))
  end
  
  def create
    @food = Food.new(food_params)
    @food.restaurant = current_user.restaurants.find(params[:resto_id])
    @food.save
    respond_with(@food, location: owner_resto_edit_path(params[:resto_id]))
  end
  
  def destroy
    @food.destroy
    respond_with(@food, location: owner_resto_edit_path(@food.restaurant))
  end
  
  private
  
  def set_food
    @food = Food.find(params[:id])  
  end
  
  def food_params
    params.require(:food).permit(:name, :description, :price, :cuisine_id)
  end
end