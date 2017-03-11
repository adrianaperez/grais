class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]
  
  #para que no requeira el token en requests de json

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
     
      respond_to do |format|
        format.json {render json: {user: user, status: :ok}.to_json}
        format.html { redirect_to dashboard_path}
        format.js
      end
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination. Try again'
      
      respond_to do |format|
        format.json {render json: {status: :unauthorized}.to_json}
        format.html { render 'new' }
        format.js
      end
        #render 'new'
    end
  end

  def destroy
  	log_out
    redirect_to root_url
  end
end
