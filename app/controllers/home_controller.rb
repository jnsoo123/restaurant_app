class HomeController < ApplicationController
  respond_to :html
  
  def index
    @restaurants = Restaurant.all
    @cuisines = Cuisine.all
  end
end
