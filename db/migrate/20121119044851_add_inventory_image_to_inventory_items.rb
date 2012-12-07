class AddInventoryImageToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :inventory_image, :string
  end
end
