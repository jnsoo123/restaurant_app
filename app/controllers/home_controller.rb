class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :html
  
  def index
    @restaurants = Restaurant.all
    @cuisines = Cuisine.all
  end
end
