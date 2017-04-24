class CreateCourseUserRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :course_user_relationships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :course, index: true
      t.belongs_to :company, index: true
      t.string :user_category
      t.string :user_occupation
      t.string :section
      t.timestamps
    end
  end
end
