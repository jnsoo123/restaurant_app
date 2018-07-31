class ChangeStatusType < ActiveRecord::Migration
  def change
    change_column :notifications, :status, 'boolean using cast(status as boolean)', default: false
  end
end
