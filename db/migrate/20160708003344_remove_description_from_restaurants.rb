class RemoveDescriptionFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :description, :text
  end
end
