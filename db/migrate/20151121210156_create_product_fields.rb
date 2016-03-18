class CreateProductFields < ActiveRecord::Migration
  def change
    create_table :product_fields do |t|
      t.string :name
      t.string :field_type
      t.boolean :require
      t.belongs_to :subcategory, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
