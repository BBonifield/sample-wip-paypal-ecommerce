class CreateShippingSpeeds < ActiveRecord::Migration
  def change
    create_table :shipping_speeds do |t|
      t.string :name
      t.integer :sort_order

      t.timestamps
    end
  end
end
