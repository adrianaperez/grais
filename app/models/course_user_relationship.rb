class CourseUserRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :company, optional: true
end
