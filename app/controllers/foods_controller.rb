class FoodsController < ApplicationController
  before_action :set_food, only: [:edit, :update, :destroy]
  
  respond_to :html
  respond_to :js, only: [:new, :edit, :create, :destroy, :update]
  
  def new
    @food = Food.new
    @food.restaurant = current_user.restaurants.find(params[:resto_id])
    respond_with(@food)
  end
  
  def edit
  end
  
  def update
    food_attributes = @food.attributes
    if @food.update(food_params) 
      unless Food.check_food?(@food.restaurant, food_params)
        @err = t('.existingfood')
        @food.update(food_attributes)
      end
      @foods = @food.restaurant.foods.page params[:page]
      respond_with(@foods)
    else     
      @err = "<dl><dt>#{t('.failurestart')}</dt>" 
      @food.errors.full_messages.map { |msg| @err << "<dd>#{msg}</dd>" }
      @err << "</dl>"
      respond_with(@foods)
    end
  end
  
  def create
    @food = Food.new(food_params)
    @food.restaurant = current_user.restaurants.find(params[:resto_id])
    if @food.save
      unless Food.check_food?(@food.restaurant, food_params)
        @err = t('.existingfood')
        @food.destroy
      end
      @foods = @food.restaurant.foods.page params[:page]
      respond_with(@foods)
    else
      @err = "<dl><dt>#{t('.failurestart')}</dt>" 
      @food.errors.full_messages.map { |msg| @err << "<dd>#{msg}</dd>" }
      @err << "</dl>"
      respond_with(@food)
    end
  end
  
  def destroy
    if @food.destroy
      @foods = @food.restaurant.foods.page params[:page]
      respond_with(@foods)
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
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