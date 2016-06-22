class Picture < ActiveRecord::Base
  mount_uploader :pic, AvatarUploader
  
  belongs_to :restaurant
  belongs_to :user
end
