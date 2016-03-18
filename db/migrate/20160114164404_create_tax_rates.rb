class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.string :code
      t.text :description
      t.decimal :rate,       precision: 8, scale: 2, default: 0.0

      t.timestamps null: false
    end
  end
end
