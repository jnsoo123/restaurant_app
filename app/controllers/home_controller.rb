class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :html
  
  def index
    @days = []
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, x] }
#    @restaurants = Restaurant.includes(:ratings).order('ratings.rate desc').where(status: 'Accepted').limit(8)
    @restaurants = Restaurant.joins(:ratings).group("restaurants.id").order("AVG(ratings.rate) DESC").limit(8)
    @new_restaurants = Restaurant.where(status: 'Accepted').order(created_at: :desc).limit(4)
    
    @cuisines = Cuisine.joins(:foods).select("cuisines.id, foods.cuisine_id, cuisines.name, cuisines.avatar").group("cuisines.id, foods.cuisine_id, cuisines.name, cuisines.avatar").order("count(foods.cuisine_id) desc").limit(4)
#    @cuisines = Cuisine.all.limit(8)
    @ratings = Rating.order(created_at: :desc).limit(4)
    @posts = Post.where(restaurant_id: Restaurant.where(status: "Accepted").map(&:id)).order(created_at: :desc).limit(4)
  end
  
  def about
  end
  
  def contact
  end
end
