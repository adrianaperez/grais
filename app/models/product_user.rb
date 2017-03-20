class ProductUser < ApplicationRecord
  belongs_to :course_user
  belongs_to :product
end
