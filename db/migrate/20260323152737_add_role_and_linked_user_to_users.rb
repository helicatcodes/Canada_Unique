class AddRoleAndLinkedUserToUsers < ActiveRecord::Migration[8.1]
  def change
    # role: 0 = user, 1 = admin, 2 = viewer. Default is 0 (user). MJR
    add_column :users, :role, :integer, default: 0, null: false
    # linked_user_id: only used for viewers — points to the child they shadow. MJR
    add_column :users, :linked_user_id, :integer
    # Remove the old admin boolean now that role handles this. MJR
    remove_column :users, :admin, :boolean
  end
end
