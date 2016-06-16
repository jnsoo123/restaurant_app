class ChangeTypeOfLocationFromUser < ActiveRecord::Migration
  def change
    change_column :users, :location, :text
  end
end
