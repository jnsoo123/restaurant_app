class AddRestaurantIdFromFoods < ActiveRecord::Migration
  def change
    add_reference :foods, :restaurant, index: true, foreign_key: true
  end
end
