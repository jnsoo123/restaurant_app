class Location < ActiveRecord::Base
  belongs_to :restaurant
  reverse_geocoded_by :latitude, :longitude, :address => :address
  after_validation :reverse_geocode
end
