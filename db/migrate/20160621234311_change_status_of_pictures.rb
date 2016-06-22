class ChangeStatusOfPictures < ActiveRecord::Migration
  def change
    change_column :pictures, :status, :boolean, default: false
  end
end
