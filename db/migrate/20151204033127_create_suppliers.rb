class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :company
      t.string :code
      t.string :status
      t.text :description

      t.timestamps null: false
    end
  end
end
