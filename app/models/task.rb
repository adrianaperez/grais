class Task < ApplicationRecord
  belongs_to :commitment
  belongs_to :user

  attr_accessor :user_name, :commitment_name # Agregar cualquier otro al metodo as_json de abajo

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:user_name, :commitment_name])
    super options
  end

end
