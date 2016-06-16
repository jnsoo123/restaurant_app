class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :admin, :boolean
    add_column :users, :profile_picture_url, :string
    add_column :users, :birth_date, :date
    add_column :users, :location, :date
  end
end
