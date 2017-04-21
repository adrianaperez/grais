class AlterTasks < ActiveRecord::Migration[5.0]
  def up
    add_column("tasks", "due_date", :date)
  end

  def down
  	remove_column("tasks", "due_date", :date)
  end
end