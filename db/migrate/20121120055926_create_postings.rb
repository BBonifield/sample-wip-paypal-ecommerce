class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.string :name
      t.string :details
      t.decimal :price
      t.integer :category_id
      t.integer :condition_id
      t.integer :user_id
      t.string :posting_image

      t.timestamps
    end
  end
end
