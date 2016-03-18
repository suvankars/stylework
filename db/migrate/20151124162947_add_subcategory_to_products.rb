class AddSubcategoryToProducts < ActiveRecord::Migration
  def change
    #add_column :products, :subcategory_id, :string
    add_column :products, :properties, :string
  end
end
