class Post < ActiveRecord::Base
  belongs_to :restaurant
  has_many :likes
  has_many :replies
  
  validates :comment, presence: true, allow_blank: false
  
  def user_liked?(user)
    likes.where(user: user).present?
  end
end
