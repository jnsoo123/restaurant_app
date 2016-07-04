class Food < ActiveRecord::Base
  belongs_to :cuisine
  belongs_to :restaurant
  
  validates :name, :price, :cuisine, presence: true
  validates_numericality_of :price, greater_than: 0
  
  def self.search_by_name(query)
    Food.where("name LIKE ?", "%#{query}%").map(&:restaurant).map(&:id).uniq
  end
  
  def self.min
    minimum(:price).to_i
  end
  
  def self.max
    maximum(:price).to_i
  end
end
