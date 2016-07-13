class Rating < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  has_many :likes
  has_many :replies
  
  validates :rate, :user, :restaurant, presence: true
  
  def user_liked?(user)
    likes.where(user: user).present?
  end
  
  def self.sort(sort_value, order)  
      if sort_value == 'Rating'
        @ratings = Rating.order("rate #{order[0]}")
        order[0] == 'ASC' ? order[0] = 'DESC' : order[0] = 'ASC'
      elsif sort_value == 'Restaurant'
        @ratings = Rating.joins("LEFT JOIN restaurants on ratings.restaurant_id = restaurants.id").order("LOWER(name) #{order[1]}")
        order[1] == 'ASC' ? order[1] = 'DESC' : order[1] = 'ASC'
      elsif sort_value == 'User'
        @ratings = Rating.joins("LEFT JOIN users on ratings.user_id = users.id").order("LOWER(name) #{order[2]}")
        order[2] == 'ASC' ? order[2] = 'DESC' : order[2] = 'ASC'
      else
        @ratings = Rating.order('updated_at DESC')
      end
      return @ratings, order
  end
end
