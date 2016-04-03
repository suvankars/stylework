class AddSubcategoryToLists < ActiveRecord::Migration
  def change
    add_reference :lists, :subcategory, index: true, foreign_key: true
  end
end
