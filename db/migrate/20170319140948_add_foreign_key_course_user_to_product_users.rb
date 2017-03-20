class AddForeignKeyCourseUserToProductUsers < ActiveRecord::Migration[5.0]
  def up
    remove_belongs_to :product_users, :user, index: true
    add_belongs_to :product_users, :course_user, index: true, foreign_key: true
  end
  def down
    add_belongs_to :product_users, :user, index: true
    remove_belongs_to :product_users, :course_user, index: true, foreign_key: true
  end
end
