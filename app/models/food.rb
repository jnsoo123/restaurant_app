class Food < ActiveRecord::Base
  belongs_to :cuisine
  belongs_to :restaurant
  
  validates :name, :price, :cuisine, presence: true, length: { maximum: 40 }, allow_blank: false
  validates_numericality_of :price, greater_than: 0
  
  def self.check_food?(resto, food_params)
    puts "RESULT: #{Food.where(name: food_params[:name], cuisine_id: food_params[:cuisine_id].to_i, restaurant_id: resto.id).count == 0}"
    puts "@@@@@@@@@@@@@@THIS IS THE RESULT: #{Food.where(name: food_params[:name], cuisine_id: food_params[:cuisine_id].to_i, restaurant_id: resto.id).inspect}"

   Food.where(name: food_params[:name], cuisine_id: food_params[:cuisine_id].to_i, restaurant_id: resto.id).count <= 1
  end
  
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
