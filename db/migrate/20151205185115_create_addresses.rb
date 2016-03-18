class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.integer :pincode
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :country
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
