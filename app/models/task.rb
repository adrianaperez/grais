class Task < ApplicationRecord
  belongs_to :commitment
  belongs_to :user
  has_one :tasks_abstract
  
  attr_accessor :user_name, :commitment_name, :user_id # Agregar cualquier otro al metodo as_json de abajo


  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:user_name, :commitment_name, :user_id])
    super options
  end

end
