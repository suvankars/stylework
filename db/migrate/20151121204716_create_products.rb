class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :skuid
      t.string :brand
      t.string   :permalink
      t.text     :description
      t.text     :short_description
      t.boolean  :active,                                       default: true
      t.integer  :quantity             
      t.decimal  :price,                 precision: 8, scale: 2, default: 0.0
      t.decimal  :cost_price,            precision: 8, scale: 2, default: 0.0
      t.boolean  :stock_control,                                default: true
      
      t.references :subcategory, index: true, foreign_key: true
      t.references :parent, index: true
      t.timestamps null: false
    end
  end
end
