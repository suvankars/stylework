class CreateStockLevels < ActiveRecord::Migration
  def change
    create_table :stock_levels do |t|
      t.date :date
      t.integer :adjustment
      t.string :description
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
