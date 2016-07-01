class Cuisine < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  has_many :foods, dependent: :destroy
  
  validates :name, :avatar, presence: true
  validates_format_of :avatar, with: %r{\.(gif|jpg|png|jpeg)\Z}i

  def self.search_by_name(query)
    Cuisine.where("name LIKE ?", "%#{query}%").map(&:foods).flatten(1).map(&:restaurant).map(&:id).uniq
  end

end
