class Schedule < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :restaurant, :day, :opening, :closing, presence: true
  
end
