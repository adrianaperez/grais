class UsersController < ApplicationController

  # TODO: Esta validacion login da prolemas para las peticiones desde la app
  skip_before_action :require_login, only: [:new, :create, :all, :find] # Comentado para pruebas Android

##para que no requeira el token
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

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
    u.password_digest = params[:password_digest]
    u.initials = params[:initials]
    u.country = params[:country]
    u.city = params[:city]
    u.phone = params[:phone]
    u.sn_one = params[:sn_one]
    u.sn_two = params[:sn_two]
    u.skills = params[:skills]
    u.image_user = "45345.png" #cambiar cuando se tenga lista la traza

    if u.save
      respond_to do |format|
        format.json {render json: u, status: :created}
      end
    else
      respond_to do |format|
        format.json {render json: u, status: :unprocessable_entity}
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

    u.names = params[:names]
    u.lastnames = params[:lastnames]
    u.email = params[:email]
    u.password_digest = params[:password_digest]
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
        format.json {render json: u, status: :ok}
      end
    else
      print u.errors.full_messages # Asi se muestran los errores
      respond_to do |format|
        format.json {render json: u, status: :unprocessable_entity}
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

    oldPasswordSaved = "" # En vez de "" obtener y desencriptar password_digest

    #comparo las claves 
    if(oldPasswordSaved ==  params[:old_password]) 
      newPasswordEncrypted = "" # En vez de "" encriptar params[:new_password] 
      u.password_digest = newPasswordEncrypted

      if u.save
        respond_to do |format|
          format.json {render json: u, status: :ok}
        end
      else
        respond_to do |format|
          format.json {render json: u, status: :unprocessable_entity}
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
          params.require(:user).permit(:names, :lastname, :email, :password_digest, :initials,
           :country, :city, :phone, :sn_one, :sn_two, :skills, :image_user)
      end
end
