class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :user, index: true, foreign_key: true
      t.references :rating, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.text :comment

      t.timestamps null: false
    end
  end
end
