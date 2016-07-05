class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :day
      t.string :opening
      t.string :closing
      t.references :restaurant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
