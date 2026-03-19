class AddColumnsToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :name, :string
    add_column :tasks, :start_date, :date
  end
end
