class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
     
      redirect_to dashboard_path
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination. Try again'
      render 'new'
    end
  end

  def destroy
  	log_out
    redirect_to root_url
  end
end
