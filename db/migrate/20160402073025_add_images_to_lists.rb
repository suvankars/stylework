class AddImagesToLists < ActiveRecord::Migration
  def change
    add_column :lists, :images, :json
  end
end

