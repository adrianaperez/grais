class Product < ApplicationRecord
  #has_many :commitments
  has_many :product_users
  has_many :course_users, through: :product_users
  has_many :commitments
  belongs_to :team
  belongs_to :prototype, optional: true


  attr_accessor :team_name

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:team_name])
    super options
  end
end
