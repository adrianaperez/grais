class ProductsController < ApplicationController

  layout "main"

  PRODUCT_LOGOS = File.join Rails.root, 'public', 'products_logos'

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    #El mismo caso que con course-teams
    #yo puedo enviar el id de team desde el formulario como hidden
    @product = Product.new(product_params);
    respond_to do |format|
      if @product.save
        format.html{redirect_to products_path , notice: "Product was created successfully"}
        format.json {render json: {product: @product, status: :ok}.to_json}
        format.js
      else
        format.html { render "new", error: "The product was not created" }
        format.json {render json: {product: @product,  status: :unprocessable_entity}.to_json }
        format.js
      end
    end
  end

  def create_product
    product = Product.new();
    product.name = params[:name]
    product.description = params[:description]
    product.logo = params[:logo]  #extension
    product.team_id = params[:team_id]
    product.initials = params[:initials]

    respond_to do |format|
      if product.save

        ########## Images
        # validar si el archivo para la imagen fue cargado al post
        if(params[:logo_file])
          # creamos si no existe la carpeta product_logos, definida al principio de este archivo
          FileUtils.mkdir_p PRODUCT_LOGOS
          
          # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
          path = File.join PRODUCT_LOGOS, product.id.inspect + "." + params[:logo]

          # Creamos el archivo y le copiamos el archivo pasado en el post 
          File.open(path, 'wb') do |f|
            f.write(params[:logo_file].read)
          end

          params[:logo_file] = nil
        end
        ###########

        ceo_id = 0; 
        # Obtener user del ceo para enviarle la notificacion
        auxList = CourseUser.where(:course => product.team.course)
        auxList.each do |auxCU|  
          if auxCU.rol == "CEO" # Es decir donde el rol es CEO
            ceo_id = auxCU.user.id
          end
        end

        currUser = User.find(params[:user_id])

        ###############################
        tokens = FcmToken.where(:user_id => ceo_id)
 
        if tokens.length > 0 && tokens[0] != nil
          uri = URI('https://fcm.googleapis.com/fcm/send')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})
 
          req.body = {:to => tokens[0].token,
           :notification => {:title => 'Han creado un producto en uno de tus equipos', :body => currUser.names + ' ha creado un producto en el equipo ' + product.team.name + ' del curso ' + product.team.course.name},
            :data => {:type => 'NEW_PRODUCT', :user_id => currUser.id, :user_name => currUser.names, :course_id => product.team.course.id, :course_name => product.team.course.name, :team_id => product.team.id, :team_name => product.team.name, :product_id => product.id}}.to_json
 
          response = http.request(req)
          ##############################
        end

        # Verofocar si el producto esta basado en un prototipo
        if params[:use_prototype] != nil && params[:use_prototype] == 'true'
          prototype = Prototype.find(params[:prototype_id])

          # Obtener el compromiso de dicho prototipo y crear un compromiso para cada uno
          commitment_prototypes = CommitmentPrototype.where(:prototype => prototype);
          commitment_prototypes.each do |cp|
            commitment = Commitment.new()
            commitment.description = cp.description
            commitment.deadline = cp.deadline
            commitment.execution = 0
            commitment.count = 0

            commitment.user = currUser.id
            commitment.product = product

            # Validate if the user and the product were found
            if currUser == nil
                format.json {render json: { info: "User not found",  status: :not_found}.to_json}
            else  # usuario encontrado
              if commitment.save
                format.html{redirect_to products_path , notice: "Product was created successfully"}
                format.json {render json: {product: product, status: :ok}.to_json}
                format.js
              else  # error con commitment.save
                format.json {render json: { info: "Error creating commitment",  status: :unprocessable_entity}.to_json}
              end
            end
          end # fin del commitent_prototypes.each 
        else  # No se uso prototipos
          format.html{redirect_to products_path , notice: "Product was created successfully"}
          format.json {render json: {product: product, status: :ok}.to_json}
          format.js
        end
      else  # error con product.save
          format.html { render "new", error: "The product was not created" }
          format.json {render json: {product: product,  status: :bad_request}.to_json }
          format.js
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update_product
    product = Product.find(params[:id])
    product.name = params[:name]
    product.description = params[:description]
    product.logo = params[:logo] # extension
    product.initials = params[:initials]
    #product.team_id = params[:team_id]

    respond_to do |format|
      if product.save

        ########## Images
        # validar si el archivo para la imagen fue cargado al post
        if(params[:logo_file])
          # creamos si no existe la carpeta product_logos, definida al principio de este archivo
          FileUtils.mkdir_p PRODUCT_LOGOS
          
          # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
          path = File.join PRODUCT_LOGOS, product.id.inspect + "." + params[:logo]

          # Creamos el archivo y le copiamos el archivo pasado en el post 
          File.open(path, 'wb') do |f|
            f.write(params[:logo_file].read)
          end

          params[:logo_file] = nil
        end
        ###########

        # Obtener user del ceo para enviarle la notificacion
        ceo_id = 0;
        auxList = CourseUser.where(:course => product.team.course)
        auxList.each do |auxCU|  
          if auxCU.rol == "CEO" # Es decir donde el rol es CEO
            ceo_id = auxCU.user.id
          end
        end

        currUser = User.find(params[:user_id])

        ##############################
        tokens = FcmToken.where(:user_id => ceo_id)

        if tokens.length > 0 && tokens[0] != nil
          uri = URI('https://fcm.googleapis.com/fcm/send')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})

          req.body = {:to => tokens[0].token,
           :notification => {:title => 'Han editado un producto en uno de tus equipos', :body => currUser.names + ' ha editado un producto en el equipo ' + product.team.name + ' del curso ' + product.team.course.name},
            :data => {:type => 'PRODUCT_UPDATE', :user_id => currUser.id, :user_name => currUser.names, :course_id => product.team.course.id, :course_name => product.team.course.name, :team_id => product.team.id, :team_name => product.team.name, :product_id => product.id}}.to_json

          response = http.request(req)
          ##############################
        end

        format.html{redirect_to team_path, notice: "Product was successfully updated"}
        format.json {render json: {product: product, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to edit product"}
        format.json {render json: {product: product, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def update
    @product = Product.find(params[:id])
    
    respond_to do |format|
      if @product.update_attributes(product_params)
        format.html{redirect_to team_path, notice: "Product was successfully updated"}
        format.json {render json: {product: @product, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to edit product"}
        format.json {render json: {product: @product, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.destroy
        format.html{redirect_to team_path, notice: "Product delete"}
        format.json {render json: {product: @product, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to delete this product"}
        format.json {render json: {product: @product, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def find_products_by_course
    @course = Course.find(params[:id])

    if @course == nil
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end
    
    @products_list = Array.new
    
    if @course.teams.any?  
      @course.teams.each do |t|
        products = t.products
        puts products.inspect
        
        if products.any?
          products.each do |pd|
            @products_list << pd
          end
        end
      end
    end
    
    respond_to do |format|
      format.html{redirect_to course_path, notice: "Success"}
      format.json {render json: {products: @products_list, status: :ok}.to_json}
      format.js
    end
  end

  def find_products_by_user
    user = User.find(params[:id])

    if user == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end  

    @product_list = Array.new
    course_users = CourseUser.where(user_id: user.id)

    if course_users.any?
      course_users.each do |cu|
        products_by_course = Product.joins(:product_users).where(product_users:{course_user_id: cu.id}) 
        if products_by_course.any?
          products_by_course.each do |product|
            @product_list << product
          end  
        end
      end
    end
  
    respond_to do |format|
      format.html{redirect_to course_path, notice: "Success"}
      format.json {render json: {products: @product_list, status: :ok}.to_json}
      format.js
    end
  end

  def find_products_by_team
    team = Team.find(params[:id])

    if team == nil
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Team not found"}
        format.json {render json: {info: "Team not found", status: :not_found}.to_json}
        format.js
      end
    end

    products = team.products
    @products_list = Array.new
    if products.any?
      products.each do |pd|
        path = "http://localhost:3000/products_logos/#{pd.id}.#{pd.logo}"
        image = open(path) { |io| io.read }
        pd.logo_img = Base64.encode64(image)

        @products_list << pd
      end
    end

    respond_to do |format|
      format.html{redirect_to teams_path, notice: "Products"}
      format.json {render json: {products:@products_list, status: :ok}.to_json}
      format.js
    end
  end

  private

    def product_params
        params.require(:product).permit(:name,:description, :logo, :team_id)
    end
end
