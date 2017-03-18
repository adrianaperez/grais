class AddForeignKeyTeamToCourseUsers < ActiveRecord::Migration[5.0]
  def up
    add_belongs_to :course_users, :team, index: true, foreign_key: true
  end

  def down
    remove_belongs_to :course_users, :team, index: true, foreign_key: true
  end
end
