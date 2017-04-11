class AlterCommitmentsAndTaks < ActiveRecord::Migration[5.0]
  def up
  	remove_column("tasks", "deadline")
  	remove_column("commitments", "execution")
  end

  def down
  	add_column("commitments", "execution", :integer)
  	add_column("tasks", "deadline", :date)
  end
end
