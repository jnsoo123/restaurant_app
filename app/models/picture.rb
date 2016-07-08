class Picture < ActiveRecord::Base
  mount_uploader :pic, AvatarUploader
  
  belongs_to :restaurant
  belongs_to :user
  
  validates :user, :restaurant, :pic, presence: true
  validates_format_of :pic, with: %r{\.(gif|jpg|png|jpeg)\Z}i
  
end
