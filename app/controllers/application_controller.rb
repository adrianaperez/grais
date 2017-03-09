class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # TODO: Estos manejadores de sesiones deben desahabilitarse para cuando se hagan
  # peticiones desde la app, o que se debe hacer?
  include SessionsHelper #comentar para pruebas en Android

  before_action :require_login #comentar para pruebas en Android
 
  private
 
  def require_login
    unless logged_in?
      #flash[:error] = "You must be logged in to access this section"
      redirect_to root_url # halts request cycle
    end
  end

end
