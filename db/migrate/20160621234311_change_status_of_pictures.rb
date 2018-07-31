class ChangeStatusOfPictures < ActiveRecord::Migration
  def change
    change_column :pictures, :status, 'boolean using cast(status as boolean)', default: false
  end
end
