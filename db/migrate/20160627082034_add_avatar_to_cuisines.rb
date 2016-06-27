class AddAvatarToCuisines < ActiveRecord::Migration
  def change
    add_column :cuisines, :avatar, :string
  end
end
