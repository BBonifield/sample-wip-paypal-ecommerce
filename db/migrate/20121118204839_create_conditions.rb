class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name
      t.integer :sort_order

      t.timestamps
    end
  end
end
