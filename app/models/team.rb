class Team < ApplicationRecord
  has_many :course_users
  has_many :products
  belongs_to :course

  attr_accessor :studentsAmount, :leader, :leader_id, :logo_file

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:studentsAmount,:leader,:leader_id, :logo_file])
    super options
  end

end
