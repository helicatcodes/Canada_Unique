class AddColumnToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :obligatory, :boolean
  end
end
