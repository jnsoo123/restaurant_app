class Food < ActiveRecord::Base
  belongs_to :cuisine
  belongs_to :restaurant
  
  def self.search_by_name(query)
    @results = Food.where("name LIKE '%#{query}%'")
    return @results
  end
end
