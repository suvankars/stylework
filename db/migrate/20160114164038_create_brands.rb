class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :short_description
      t.text :description
      t.string :location

      t.timestamps null: false
    end
  end
end
