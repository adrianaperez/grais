class Prototype < ApplicationRecord
	belongs_to :course
	has_many :commitment_prototypes
end
