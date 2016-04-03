class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :ride_title
      t.text :ride_description
      t.string :rider_height
      t.string :frame_size
      t.decimal :hourly_rental
      t.decimal :morning_rental
      t.decimal :evening_rental
      t.decimal :daily_rental
      t.decimal :weekly_rental
      t.boolean :willing_to_deliver
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :state
      t.integer :pincode
      t.string :landmark

      t.timestamps null: false
    end
  end
end