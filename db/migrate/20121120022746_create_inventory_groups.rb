class CreateInventoryGroups < ActiveRecord::Migration
  def change
    create_table :inventory_groups do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
