class AddColumnsToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :restaurant, index: true, foreign_key: true
    add_column :posts, :comment, :text
  end
end
