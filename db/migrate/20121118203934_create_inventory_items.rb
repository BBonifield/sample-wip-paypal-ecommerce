class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.string :name
      t.integer :user_id
      t.integer :category_id
      t.integer :condition_id
      t.integer :quantity
      t.decimal :shipping_cost
      t.integer :shipping_speed_id
      t.text :details
      t.string :keyword_1
      t.string :keyword_2
      t.string :keyword_3
      t.string :keyword_4
      t.string :keyword_5
      t.string :keyword_6

      t.timestamps
    end
  end
end
