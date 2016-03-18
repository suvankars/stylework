class AddSizeRefToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :size, index: true, foreign_key: true
  end
end
