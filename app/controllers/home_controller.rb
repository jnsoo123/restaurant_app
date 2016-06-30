class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :html
  
  def index
    @restaurants = Restaurant.includes(:ratings).order('ratings.rate desc').where(status: 'Accepted').limit(6)
    @cuisines = Cuisine.all
    @ratings = Rating.order(created_at: :desc)
  end
  
  def about
  end
  
  def contact
  end
end
