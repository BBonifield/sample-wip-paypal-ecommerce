class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :posting_id
      t.integer :inventory_item_id
      t.decimal :price
      t.string :state, :default => 'pending'

      t.timestamps
    end
  end
end
