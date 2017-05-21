class UsersController < ApplicationController

  # TODO: Esta validacion login da prolemas para las peticiones desde la app
  skip_before_action :require_login, only: [:new, :create]

  layout "main", only: [:show]

  USER_IMGS = File.join Rails.root, 'public', 'user_imgs'

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html{redirect_to user_path, notice: "User was successfully updated"}
        format.json {render json:{user: @user, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to update this user"}
        format.json {render json: {info: "Failed to update this user", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        format.html{redirect_to teams_path, notice: "User delete"}
        format.json {render json: {info: "User delete", status: :ok}.to_json}
        format.js
      else
        format.html { redirect_to users_path, error: "Failed to delete this user"}
        format.json {render json: {info: "Failed to delete this user", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  # get all the users
  def all
    users = User.all

    if users.any?
      users.each do |u|
        if u.image_user == "png" || u.image_user == "jpg" || u.image_user == "jpeg"
          path = "http://localhost:3000/user_imgs/#{u.id}.#{u.image_user}"
          image = open(path) { |io| io.read }
          
          u.img = Base64.encode64(image)
        end
      end
    end

    respond_to do |format|
      format.json {render json: users}
    end
  end

  # return 1 user data
  def find
    u = User.find(params[:id])

    if u != nil
      if u.image_user == "png" || u.image_user == "jpg" || u.image_user == "jpeg"
        path = "http://localhost:3000/user_imgs/#{u.id}.#{u.image_user}"
        image = open(path) { |io| io.read }
        
        u.img = Base64.encode64(image)
      end
    end

    if u != nil
      respond_to do |format|
        format.json {render json: {user: u, status: :ok}.to_json}
      end
    else
      respond_to do |format|
        format.json {render json: {user: u, status: :not_found}.to_json}

      end
    end
  end

  # create 1 user
  def create_user
    u = User.new
    u.names = params[:names]
    u.lastnames = params[:lastnames]
    u.email = params[:email]
    u.password = params[:password]
    u.password_confirmation = params[:password]
    u.initials = params[:initials]
    u.country = params[:country]
    u.city = params[:city]
    u.phone = params[:phone]
    u.sn_one = params[:sn_one]
    u.sn_two = params[:sn_two]
    u.skills = params[:skills]
    u.image_user = "45345.png" #cambiar cuando se tenga lista la traza

    #buscar registros que coincidan con el email del usario que se esta creando (params[:email])
    #y si hay alguna coincidencia devolver error
    mailLists = User.where("email = ?", u.email)

    if(mailLists.length == 0)
      if u.save

        ########## Images
        # validar si el archivo para la imagen fue cargado al post
        if(params[:img_file])
          # creamos si no existe la carpeta product_logos, definida al principio de este archivo
          FileUtils.mkdir_p USER_IMGS
          
          # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
          path = File.join USER_IMGS, u.id.inspect + "." + params[:image_user]

          # Creamos el archivo y le copiamos el archivo pasado en el post 
          File.open(path, 'wb') do |f|
            f.write(params[:img_file].read)
          end

          params[:img_file] = nil
        end
        ###########

        if params[:fcm_token] != nil
          fcm_token = FcmToken.new()
          fcm_token.token = params[:fcm_token]
          fcm_token.user_id = u.id
          
          # validate ?
          fcm_token.save
        end

        @user = u
        log_in @user
        
        respond_to do |format|
          format.json {render json: {user: u, status: :created}.to_json}
          format.html{redirect_to dashboard_path}
        end
      else
        respond_to do |format|
          format.json {render json: {user: u, status: :unprocessable_entity}.to_json}
          format.html{render 'new'}
        end
      end
    
    else
      respond_to do |format|
        format.json {render json:  {info: "Este correo ya existe", status: :not_acceptable}.to_json}
        format.html{render 'new'}
      end 
    end
  end

  # update 1 user
  def update_user
    u = User.find(params[:id])

    if u == nil
      respond_to do |format|
        format.json {render json: u, status: :not_found}
      end
    end
    
    puts u.inspect

    u.names = params[:names]
    u.lastnames = params[:lastnames]
    #u.email = params[:email] #agregado
    u.password = params[:password] #agregado
    u.password_confirmation = params[:password] #agregado
    u.initials = params[:initials]
    u.country = params[:country]
    u.city = params[:city]
    u.sn_one = params[:sn_one]
    u.sn_two = params[:sn_two]
    u.phone = params[:phone]
    u.skills = params[:skills]
    u.image_user = params[:image_user]

    if u.save

      ########## Images
      # validar si el archivo para la imagen fue cargado al post
      if(params[:img_file])
        # creamos si no existe la carpeta product_logos, definida al principio de este archivo
        FileUtils.mkdir_p USER_IMGS
        
        # Creamos el path del archivo concatenando carpeta mas nombre del archivo 
        path = File.join USER_IMGS, u.id.inspect + "." + params[:image_user]

        # Creamos el archivo y le copiamos el archivo pasado en el post 
        File.open(path, 'wb') do |f|
          f.write(params[:img_file].read)
        end

        params[:img_file] = nil
      end
      ###########

      respond_to do |format|
        format.json {render json: {user: u, status: :ok}.to_json}
      end
    else
      print u.errors.full_messages # Asi se muestran los errores
      respond_to do |format|
        format.json {render json: {user: u, status: :unprocessable_entity}.to_json}
      end
    end
  end

 # change of password the 1 user
 def change_password
   u = User.find(params[:id])

   if u == nil
      respond_to do |format|
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
      end
    end

    #comparo las claves 
    if(u.authenticate(params[:old_password])) 
      u.password = params[:new_password]
      u.password_confirmation = params[:new_password]

      if u.save
        respond_to do |format|
          format.json {render json: {user: u, status: :ok}.to_json}
        end
      else
        respond_to do |format|
          format.json {render json: {info: "Error saving data", status: :unprocessable_entity}.to_json}
        end
      end #cierre del if
    else
      respond_to do |format|
        format.json {render json:  {info: "Wrong password", status: :unauthorized}.to_json}
      end      
    end

 end
  # Se coloco al final para que no de peos con las acciones de la app, tambien se agrego los campos faltantes
  private
      def user_params
          #Se agrega password y password_confirmation, no password_digest.
          #En Rails dice que se puede obviar, al ser nulo el sabrá que no
          #tiene que hacer comparación, pero imagino que se mantiene password en vez de password_digest
          #Ve al link de github para que veas lo que hacen. Al final del siguiente link
          #http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
          #Gracias por la ayuda. Recuerde que parte de lo que no puedo hacer resulta de mi poco conocimiento.
          params.require(:user).permit(:names, :lastnames, :email, :password, :password_confirmation, :initials,
           :country, :city, :phone, :sn_one, :sn_two, :skills, :image_user)
      end
end
