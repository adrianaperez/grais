class UsersController < ApplicationController

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
      redirect_to @user
    else
      render 'new'
    end
  end

   private

      def user_params
      	  params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation,
      	   :birth_date, :sex, :phone, :country, :state, :twitter_account, :skills)
      end

  def edit
  end

  def update
  end

  def destroy
  end
end
