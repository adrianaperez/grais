class Course < ApplicationRecord
  has_many :course_user_relationships
  has_many :users, through: :course_user_relationships

  
end
