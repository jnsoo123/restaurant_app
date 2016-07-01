class RemoveDescriptionFromCuisines < ActiveRecord::Migration
  def change
    remove_column :cuisines, :description, :text
  end
end
