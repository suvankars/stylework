class AddImagesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :images, :string, array: true, default: []
    add_column :products, :image_name, :string
  end
end
