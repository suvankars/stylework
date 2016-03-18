class CreateFinances < ActiveRecord::Migration
  def change
    create_table :finances do |t|
      t.string :price_list
      t.string :currency
      t.string :tax_code
      t.string :email
      t.string :registration_number
      t.string :payment_method
      t.integer :credit_limit
      t.integer :credit_lead_time
      t.string :bank_name
      t.integer :account_number
      t.string :IFSC_code
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
