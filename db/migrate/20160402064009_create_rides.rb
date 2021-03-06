class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :title
      t.text :description
      t.string :amenities
      t.decimal :number_of_workstations
      t.decimal :hourly_rental
      t.decimal :morning_rental
      t.decimal :evening_rental
      t.decimal :daily_rental
      t.decimal :weekly_rental
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode
      t.string :landmark

      t.timestamps null: false
    end
  end
end