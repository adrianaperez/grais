class Commitment < ApplicationRecord
  belongs_to :product
  has_many :tasks
end
