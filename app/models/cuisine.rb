class Cuisine < ActiveRecord::Base
  has_many :foods

  def self.search_by_name(query)
    @results = Cuisine.where("name LIKE '%#{query}%'")
    return @results
  end

end
