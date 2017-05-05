class CommitmentPrototype < ApplicationRecord
	belongs_to :prototype
  has_many :commitments
end
