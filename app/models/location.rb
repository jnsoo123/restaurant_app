class Location < ActiveRecord::Base
  belongs_to :restaurant
  reverse_geocoded_by :latitude, :longitude, :address => :address, unless: :have_address?
  geocoded_by :address, if: :have_address?
  after_validation :reverse_geocode, unless: :have_address?
  after_validation :geocode, if: :have_address?
  
  def have_address?
    address.present?
  end
end
