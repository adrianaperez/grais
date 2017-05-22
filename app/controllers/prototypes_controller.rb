class PrototypesController < ApplicationController

  layout "main"
  PROTOTYPES_LOGOS = File.join Rails.root, 'public', 'prototypes_logos'
  PRODUCT_LOGOS = File.join Rails.root, 'public', 'products_logos'

  def index
    @prototypes = Prototype.all
  end

  def show
    @prototype = Prototype.find(params[:id])
    @commitment_prototype = CommitmentPrototype.new
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params);
    respond_to do |format|
      if @prototype.save
        format.html{redirect_to prototypes_path , notice: "Prototype was created successfully"}
        format.json {render json: {prototype: @prototype, status: :ok}.to_json}
        format.js
      else
        format.html { render "new", error: "The prototype was not created" }
        format.json {render json: {prototype: @prototype,  status: :unprocessable_entity}.to_json }
        format.js
      end
    end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    
    respond_to do |format|
      if @prototype.update_attributes(prototype_params)

        #Actualizar todos los productos
        @products = Product.where(prototype_id:@prototype.id)

        @products.each do |p|
          p.name = @prototype.name
          p.description = @prototype.description
          p.logo = @prototype.logo
          p.initials = @prototype.initials
          p.save
        end

        format.html{redirect_to prototype_path, notice: "Prototype was successfully updated"}
        format.json {render json: {prototype: @prototype, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to edit prototype"}
        format.json {render json: {prototype: @prototype, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @prototype = Product.find(params[:id])
    respond_to do |format|
      if @prototype.destroy
        format.html{redirect_to prototype_path, notice: "Prototype delete"}
        format.json {render json: {prototype: @prototype, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to delete this prototype"}
        format.json {render json: {prototype: @prototype, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

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

          #params[:logo_file] = nil # se necesitara para copiarlo en los productos que usan este product
        end
        ###########

        course = prototype.course
        teams = course.teams

        # Para cada equipo actualizar sus productos
        teams.each do |t|
          t.products.each do |p|
            if p.prototype_id == prototype.id
              p.name = params[:name]
              p.description = params[:description]
              p.logo = params[:logo]  #extension
              p.initials = params[:initials]

              ########## Images
              # validar si el archivo para la imagen fue cargado al post
              if(params[:logo_file])
                # creamos si no existe la carpeta product_logos, definida al principio de este archivo
                FileUtils.mkdir_p PRODUCT_LOGOS
                
                # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
                path = File.join PRODUCT_LOGOS, p.id.inspect + "." + p.logo

                # Creamos el archivo y le copiamos el archivo pasado en el post 
                File.open(path, 'wb') do |f|
                  f.write(params[:logo_file].read)
                end

                #params[:logo_file] = nil
              end
              ###########

              p.save
            end
          end
        end

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

  def find_teams_by_prototype

    prototype = Prototype.find(params[:prototype_id])

    course = prototype.course

    teams = course.teams

    team_list = Array.new

    teams.each do |t|
      if t.prototype_id == prototype.id
        team_list << t       
      end
    end
    respond_to do |format|
      format.json {render json: {teams: team_list, status: :ok}.to_json}
    end
  end

  private

    def prototype_params
        params.require(:prototype).permit(:name, :description, :logo, :initials, :course_id)
    end

end
