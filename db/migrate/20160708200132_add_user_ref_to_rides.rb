class AddUserRefToRides < ActiveRecord::Migration
  def change
    add_reference :rides, :user, index: true, foreign_key: true
  end
end
