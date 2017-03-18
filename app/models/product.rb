class Product < ApplicationRecord
  #has_many :commitments
  has_many :product_users
  has_many :users, through: :product_users
  belongs_to :team

end
