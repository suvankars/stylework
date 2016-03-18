class AddTaxRateRefToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :tax_rate, index: true, foreign_key: true
  end
end
