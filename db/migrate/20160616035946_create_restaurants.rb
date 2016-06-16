class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.text :address
      t.string :contact
      t.string :status
      t.decimal :low_price_range
      t.decimal :high_price_range
      t.text :map

      t.timestamps null: false
    end
  end
end
