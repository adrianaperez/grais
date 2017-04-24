class DropCourseUserRelationShips < ActiveRecord::Migration[5.0]
  def up
    drop_table("course_user_relationships")
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
