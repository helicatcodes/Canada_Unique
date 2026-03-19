class ReplaceAdminWithRoleOnUsers < ActiveRecord::Migration[8.1]
  def up
    # Add role column with 'student' as the default for all new and existing users. MJR
    add_column :users, :role, :string, default: "student", null: false

    # Migrate existing admins so they keep their admin role after the column swap. MJR
    execute "UPDATE users SET role = 'admin' WHERE admin = true"

    # Remove the old boolean admin column now that role covers the same ground. MJR
    remove_column :users, :admin
  end

  def down
    # Restore the boolean admin column when rolling back. MJR
    add_column :users, :admin, :boolean, default: false, null: false

    # Re-populate admin flag from the role column. MJR
    execute "UPDATE users SET admin = true WHERE role = 'admin'"

    # Drop the role column on rollback. MJR
    remove_column :users, :role
  end
end
