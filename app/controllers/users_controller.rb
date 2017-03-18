class UsersController < ApplicationController

  # TODO: Esta validacion login da prolemas para las peticiones desde la app
  skip_before_action :require_login, only: [:new, :create]

  def index
  end

  def show
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
  end

  def update
  end

  def destroy
  end

  # get all the users
  def all
    users = User.all
    
    puts users.inspect

      respond_to do |format|
        format.json {render json: users}
      end
  end

  # return 1 user data
  def find
    u = User.find(params[:id])

    if u != nil
      respond_to do |format|
        format.json {render json: u, status: :ok}
      end
    else
      respond_to do |format|
        format.json {render json: u, status: :not_found}
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
    u.image_user = '45345.png'   #cambiar cuando se tenga lista la traza

    if u.save
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
