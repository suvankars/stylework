class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :morning_ride
      t.boolean :evening_ride
      t.boolean :all_day
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
