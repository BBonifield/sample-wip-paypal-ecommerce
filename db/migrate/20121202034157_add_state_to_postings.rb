class AddStateToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :state, :string, :default => 'active'
  end
end
