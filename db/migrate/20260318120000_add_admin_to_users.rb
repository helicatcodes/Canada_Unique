# Adds admin boolean to users table. Used to control access to notification creation. MJR
class AddAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
