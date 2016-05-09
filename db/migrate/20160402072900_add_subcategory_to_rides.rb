class AddSubcategoryToRides < ActiveRecord::Migration
  def change
    add_reference :rides, :subcategory, index: true, foreign_key: true
  end
end
