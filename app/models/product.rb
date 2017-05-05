class Product < ApplicationRecord
  #has_many :commitments
  has_many :product_users
  has_many :course_users, through: :product_users
  has_many :commitments
  belongs_to :team
  belongs_to :prototype, optional: true
  has_one :product_report


  attr_accessor :logo_img, :team_name # Agregar cualquier otro al metodo as_json de abajo

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:logo_img, :team_name])
    super options
  end

end
