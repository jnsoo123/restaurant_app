class ChangeDefaultTypeOfStatusInRestaurants < ActiveRecord::Migration
  def change
    change_column :restaurants, :status, :string, default: 'Pending'
  end
end
