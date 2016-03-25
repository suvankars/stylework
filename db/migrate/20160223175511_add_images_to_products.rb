class AddImagesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :images, :string, array: true, default: []
    add_column :products, :image_name, :string
    add_column :products, :image_id, :string
    add_column :products, :cloudinary_images, :text
  end
end
