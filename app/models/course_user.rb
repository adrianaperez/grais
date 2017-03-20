class CourseUser < ApplicationRecord
	belongs_to :user
	belongs_to :course
  belongs_to :team, optional: true #optional true permite que no requiera obligatoriamente la asociacion con un equipo
  has_many :product_users
  has_many :products, through: :product_users 
end
