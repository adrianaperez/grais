class Task < ApplicationRecord
  belongs_to :commitment
  belongs_to :user
end
