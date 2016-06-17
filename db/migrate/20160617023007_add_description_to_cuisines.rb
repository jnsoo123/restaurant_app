class AddDescriptionToCuisines < ActiveRecord::Migration
  def change
    add_column :cuisines, :description, :text
  end
end
