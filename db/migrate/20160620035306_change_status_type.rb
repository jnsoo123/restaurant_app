class ChangeStatusType < ActiveRecord::Migration
  def change
    change_column :notifications, :status, :boolean, default: false
  end
end
