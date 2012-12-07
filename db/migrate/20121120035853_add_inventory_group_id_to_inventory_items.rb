class AddInventoryGroupIdToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :inventory_group_id, :integer
  end
end
