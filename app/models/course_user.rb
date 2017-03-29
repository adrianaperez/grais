class CourseUser < ApplicationRecord
	belongs_to :user
	belongs_to :course
  	belongs_to :team, optional: true #optional true permite que no requiera obligatoriamente la asociacion con un equipo
  	has_many :product_users
  	has_many :products, through: :product_users 

   	attr_accessor :names_user, :lastnames_user, :name_team, :image_user# Agregar cualquier otro al metodo as_json de abajo

	# Sobreescribir la funcion as_json
	def as_json options=nil
	  options ||= {}
	  options[:methods] = ((options[:methods] || []) + [:names_user, :lastnames_user, :name_team, :image_user])
	  super options
	end
end
