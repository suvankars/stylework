class AddImagesToRides < ActiveRecord::Migration
  def change
    add_column :rides, :images, :json
  end
end

