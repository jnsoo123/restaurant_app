class RemoveLowPriceRangeFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :low_price_range, :decimal
    remove_column :restaurants, :high_price_range, :decimal
  end
end
