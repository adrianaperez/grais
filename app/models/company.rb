class Company < ApplicationRecord
  has_many :course_user_relationships
  belongs_to :product
  has_many :commitments
end
