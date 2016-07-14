class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :html
  
  def index
    @days = []
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, x] }
    @restaurants = Restaurant.includes(:ratings).order('ratings.rate desc').where(status: 'Accepted').limit(8)
    @cuisines = Cuisine.joins(:foods).group("foods.cuisine_id").order("count(foods.cuisine_id) desc").limit(4)
#    @cuisines = Cuisine.all.limit(8)
    @ratings = Rating.order(created_at: :desc).limit(4)
    @posts = Post.order(created_at: :desc).limit(4)
  end
  
  def about
  end
  
  def contact
  end
end
