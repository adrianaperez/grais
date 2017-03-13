class UsersController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  layout "base", only: [:show]

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
  end

  def destroy
  end

  private

    def user_params
        params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation,
         :birth_date, :sex, :phone, :country, :state, :twitter_account, :skills)
    end
end
