class Rating < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  
  def self.sort(sort_value)
      if sort_value == 'Rating'
        @ratings = Rating.order('rate DESC')
      elsif sort_value == 'Restaurant'
        @ratings = Rating.joins("LEFT JOIN restaurants on ratings.restaurant_id = restaurants.id").order('LOWER(name)')
      elsif sort_value == 'User'
        @ratings = Rating.joins("LEFT JOIN users on ratings.user_id = users.id").order("LOWER(name)")
      else
        @ratings = Rating.order('updated_at DESC')
      end
      return @ratings
  end
end
