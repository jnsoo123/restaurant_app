class Location < ActiveRecord::Base
  belongs_to :restaurant
  reverse_geocoded_by :latitude, :longitude, :address => :address
  geocoded_by :address
  after_validation :reverse_geocode
  after_validation :geocode, if: :have_address?
  
  def have_address?
    address.present?
  end
end
