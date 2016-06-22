class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :pictures, :picture, :pic
  end
end
