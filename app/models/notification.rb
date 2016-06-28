class Notification < ActiveRecord::Base
  belongs_to :user
  
  validates :message, :user, presence: true
  
end
