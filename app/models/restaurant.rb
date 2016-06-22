class Restaurant < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader
  
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :pictures, dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :contact, presence: true
  
  def ave_ratings
    ratings.collect(&:rate).sum.to_f/ratings.size unless ratings.empty?
  end
  
  def self.search_by_name(query)
    @results = Restaurant.where("name LIKE '%#{query}%'")
    return @results
  end
end
