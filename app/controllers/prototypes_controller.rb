class PrototypesController < ApplicationController

  PROTOTYPES_LOGOS = File.join Rails.root, 'public', 'prototypes_logos'

	def create_prototype
    prototype = Prototype.new();
    prototype.name = params[:name]
    prototype.description = params[:description]
    prototype.logo = params[:logo]  #extension
    prototype.course_id = params[:course_id]
    prototype.initials = params[:initials]

    respond_to do |format|
      if prototype.save

        ########## Images
        # validar si el archivo para la imagen fue cargado al post
        if(params[:logo_file])
          # creamos si no existe la carpeta product_logos, definida al principio de este archivo
          FileUtils.mkdir_p PROTOTYPES_LOGOS
          
          # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
          path = File.join PROTOTYPES_LOGOS, prototype.id.inspect + "." + params[:logo]

          # Creamos el archivo y le copiamos el archivo pasado en el post 
          File.open(path, 'wb') do |f|
            f.write(params[:logo_file].read)
          end

          params[:logo_file] = nil
        end
        ###########

        format.json {render json: {prototype: prototype, status: :ok}.to_json}
      else
      end
    end
	end

	def update_prototype
    prototype = Prototype.find(params[:id])
    prototype.name = params[:name]
    prototype.description = params[:description]
    prototype.logo = params[:logo]  #extension
    prototype.initials = params[:initials]

    respond_to do |format|
      if prototype.save

        ########## Images
        # validar si el archivo para la imagen fue cargado al post
        if(params[:logo_file])
          # creamos si no existe la carpeta product_logos, definida al principio de este archivo
          FileUtils.mkdir_p PROTOTYPES_LOGOS
          
          # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
          path = File.join PROTOTYPES_LOGOS, prototype.id.inspect + "." + params[:logo]

          # Creamos el archivo y le copiamos el archivo pasado en el post 
          File.open(path, 'wb') do |f|
            f.write(params[:logo_file].read)
          end

          params[:logo_file] = nil
        end
        ###########

        format.json {render json: {prototype: prototype, status: :ok}.to_json}
      else
        format.json {render json: {prototype: prototype, status: :unprocessable_entity}.to_json}
      end
    end
	end

	def find_by_course
	    course = Course.find(params[:id])

	    if course == nil
	      respond_to do |format|
	        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
	      end
	    end

	    prototypes = course.prototypes

	    respond_to do |format|
	      format.json {render json: {prototypes: prototypes, status: :ok}.to_json}
	    end
	end

end
