class Product < ApplicationRecord
  has_many :companies
  has_many :commitments
end
