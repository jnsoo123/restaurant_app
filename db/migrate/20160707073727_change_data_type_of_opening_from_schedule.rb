class ChangeDataTypeOfOpeningFromSchedule < ActiveRecord::Migration
  def change
    change_column :schedules, :opening, :time
    change_column :schedules, :closing, :time
  end
end
