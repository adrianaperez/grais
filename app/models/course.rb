class Course < ApplicationRecord
  has_many :course_user_relationships
  has_many :users, through: :course_user_relationships
  
  has_and_belongs_to_many :course_users #new

  attr_accessor :studentsAmount, :ceo, :ceo_id # Agregar cualquier otro al metodo as_json de abajo

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:studentsAmount, :ceo, :ceo_id])
    super options
  end
end
