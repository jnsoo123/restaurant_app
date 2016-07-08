class ChangeDataTypeOfSchedule < ActiveRecord::Migration
  def change
    change_column :schedules, :opening, :string
    change_column :schedules, :closing, :string
  end
end