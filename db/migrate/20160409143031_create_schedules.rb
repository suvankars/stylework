class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.boolean :morning_ride
      t.boolean :evening_ride
      t.boolean :all_day
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
