class CuisinesController < ApplicationController
  before_action :set_cuisine, only: [:edit, :update, :destroy]
  
  def index
    @cuisines = Cuisine.order('updated_at DESC')
  end

  def new
    @cuisine = Cuisine.new
  end

  def create
    @cuisine = Cuisine.new(cuisine_params)
    @cuisine.save
    redirect_to cuisines_path
  end

  def edit
  end

  def update
    @cuisine.update(cuisine_params)
    redirect_to cuisines_path
  end

  def destroy
    @cuisine.destroy
    redirect_to cuisines_path
  end
  
  private
  def set_cuisine
    @cuisine = Cuisine.find(params[:id])
  end
  
  def cuisine_params
    params.require(:cuisine).permit(:name, :description)
  end

end