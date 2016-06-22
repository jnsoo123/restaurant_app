class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.boolean :status
      t.references :user, index: true, foreign_key: true
      t.string :picture

      t.timestamps null: false
    end
  end
end
