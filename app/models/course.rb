class Course < ApplicationRecord
  has_many :course_user_relationships
  has_many :users, through: :course_user_relationships
  
  has_and_belongs_to_many :course_users #new
  
end
