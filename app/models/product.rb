class Product < ApplicationRecord
  #has_many :commitments
  has_many :product_users
  has_many :course_users, through: :product_users
  has_many :commitments
  belongs_to :team
end
