class Restaurant < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader
  
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :pictures, dependent: :destroy
  
  validates :name, :description, :address, :contact, :user, presence: true

  def ave_ratings
    unless ratings.empty?
      ratings.collect(&:rate).sum.to_f/ratings.size 
    else
      0
    end
  end
  
  def min_price
    foods.minimum(:price).to_i
  end
  
  def max_price
    foods.maximum(:price).to_i
  end
  
  def self.search_by_name(query)
    Restaurant.where("name LIKE ?","%#{query}%").map(&:id)
  end
end
