class DropCourseUserRelationshis < ActiveRecord::Migration[5.0]
  def up
    drop_table :course_user_relationships
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
