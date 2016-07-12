class Post < ActiveRecord::Base
  belongs_to :restaurant
  has_many :likes
  has_many :replies
  
  def user_liked?(user)
    likes.where(user: user).present?
  end
end
