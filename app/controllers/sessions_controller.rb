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

      if params[:fcm_token] != nil
        fcm_tokens = FcmToken.where(:token => params[:fcm_token])

        # If the token exists (the device has been used), update the user
        if fcm_tokens.length > 0 && fcm_tokens[0] != nil
          fcm_tokens[0].user_id = user.id
          fcm_tokens[0].save
        else  # it's a new device, check if the user have a token assigned
          fcm_tokens = FcmToken.where(:user_id => user.id)

          if fcm_tokens.length > 0 && fcm_tokens[0] != nil # and update it
            fcm_tokens[0].token = params[:fcm_token]
            fcm_tokens[0].save
          else  # this should not happens, the user don't have a token (device)
            fcm_token = FcmToken.new()

            fcm_token.user_id = user.id
            fcm_token.token = params[:fcm_token]
            fcm_token.save
          end
        end
      end
     
      respond_to do |format|
        format.json {render json: {user: user, status: :ok}.to_json}
        format.html { redirect_to dashboard_path}
        format.js
      end
    else
      # Create an error message.
      flash.now[:danger] = 'La combinación correo/contrasena no coincide'
      
      respond_to do |format|
        format.json {render json: {status: :unauthorized}.to_json}
        format.html { render 'new', notice:"Mensaje de error" }
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
