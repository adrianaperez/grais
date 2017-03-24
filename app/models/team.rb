class Team < ApplicationRecord
  has_many :course_users
  has_many :products
  belongs_to :course

  attr_accessor :studentsAmount

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:studentsAmount])
    super options
  end

end
