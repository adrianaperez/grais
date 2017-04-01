class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #comentar para pruebas en Android
  include CoursesHelper
  include TeamsHelper

  before_action :require_login #comentar para pruebas en Android

  skip_before_action :require_login,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  skip_before_action :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
 
  private
 
  def require_login
    unless logged_in?
      # Descomentar este codigo si se quiere permitir la revision de credenciales
      # y dejar proceder los requests tipo json sin manejar sesiones
      ##Si no esta logeado
      ##Buscar al usuario dado el parametro session (que contiene correo y clave)
      #user = User.find_by(email: params[:session][:email].downcase)

      #if user && user.authenticate(params[:session][:password])
      #  puts "Continuar, el usuario esta autorizado."
      #else
      #  respond_to do |format|
      #    format.json {render json: {status: :unauthorized}.to_json}
      #    format.html {redirect_to root_url}
      #    format.js
      #  end 
      #end


      #flash[:error] = "You must be logged in to access this section"
       # halts request cycle
      redirect_to root_url
    end
  end

end
