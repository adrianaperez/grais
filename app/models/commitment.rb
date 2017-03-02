class Commitment < ApplicationRecord
  has_many :commitment_user_relationships
  has_many :users, through: :commitment_user_relationships
  belongs_to :company
  belongs_to :product
  has_many :tasks
end
