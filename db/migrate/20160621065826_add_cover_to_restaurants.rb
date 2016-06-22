class AddCoverToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :cover, :string
  end
end
