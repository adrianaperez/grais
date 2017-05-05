class Commitment < ApplicationRecord
  belongs_to :product
  has_many :tasks
  belongs_to :commitment_prototype, optional: true

  attr_accessor :product_logo, :product_name, :execution # Agregar cualquier otro al metodo as_json de abajo

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:product_logo, :product_name, :execution])
    super options
  end

end
