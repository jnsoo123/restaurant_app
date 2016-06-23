class Cuisine < ActiveRecord::Base
  has_many :foods, dependent: :destroy

  def self.search_by_name(query)
#    @results = Cuisine.where("name LIKE '%#{query}%'").
#    return @results
    @results = Cuisine.where('name LIKE ?', "%#{query}%").map { |cuisine| cuisine.foods.map { |food| food.restaurant.id } }
    return @results.flatten(1).uniq
  end

end
