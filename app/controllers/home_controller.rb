class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :html
  
  def index
    @restaurants = Restaurant.includes(:ratings).order('ratings.rate desc').where(status: 'Accepted').limit(12)
    @cuisines = Cuisine.all.limit(12)
    @ratings = Rating.order(created_at: :desc).limit(4)
  end
  
  def about
  end
  
  def contact
  end
end
