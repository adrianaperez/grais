class Team < ApplicationRecord
  has_many :course_users
  has_many :products
  belongs_to :course
end
