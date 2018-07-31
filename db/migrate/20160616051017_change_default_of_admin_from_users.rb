class ChangeDefaultOfAdminFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :admin, 'boolean using cast(admin AS boolean)', default: false
  end
end
