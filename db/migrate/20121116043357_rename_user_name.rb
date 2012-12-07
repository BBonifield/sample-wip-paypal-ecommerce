class RenameUserName < ActiveRecord::Migration
  def up
    rename_column :users, :username, :user_name
  end

  def down
    rename_column :users, :user_name, :username
  end
end