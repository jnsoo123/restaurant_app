class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.references :restaurant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
