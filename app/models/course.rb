class Course < ApplicationRecord
  has_many :course_users
  has_many :users, through: :course_users
  
  #Esta asosiacion es solo si la asosiacion es directa. En este caso es indirecta pues cuenta con un modelo intermedio
  #Por tal razon se utiliza has_many :course_users y has_many :users, through: :course_users
  #has_and_belongs_to_many :course_users #new


  attr_accessor :studentsAmount, :ceo, :ceo_id # Agregar cualquier otro al metodo as_json de abajo

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:studentsAmount, :ceo, :ceo_id])
    super options
  end

end
