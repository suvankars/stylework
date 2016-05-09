class AddCategoryToRides < ActiveRecord::Migration
  def change
    add_reference :rides, :category, index: true, foreign_key: true
  end
end
