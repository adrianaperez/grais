class Team < ApplicationRecord
  has_many :course_users
  has_many :products
  belongs_to :course

  attr_accessor :studentsAmount,:leader,:leader_id

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:studentsAmount,:leader,:leader_id])
    super options
  end

end
