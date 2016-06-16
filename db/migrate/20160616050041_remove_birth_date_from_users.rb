class RemoveBirthDateFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :birth_date, :date
  end
end
