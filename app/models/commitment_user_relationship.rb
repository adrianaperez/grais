class CommitmentUserRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :commitment
end
