class Food < ActiveRecord::Base
  belongs_to :cuisine
  belongs_to :restaurant
end
