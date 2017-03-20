class TeamsController < ApplicationController

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    #Se necesita el id del curso
    #yo lo puedo pasar desde el formulario como hidden
    @team = Team.new(team_params);
    respond_to do |format|
      if @team.save
        format.html{redirect_to teams_path , notice: "Team was created successfully"}
        format.json {render json:  {team: @team, status: :ok}.to_json}
        format.js
      else
        format.html { render "new", error: "Failed to create team" }
        format.json {render json: { team: @team,  status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    
    respond_to do |format|
      if @team.update_attributes(team_params)
        format.html{redirect_to teams_path, notice: "Team was successfully updated"}
        format.json {render json:{team: @team, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to edit team"}
        format.json {render json: {team: @team, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    respond_to do |format|
      if @team.destroy
        format.html{redirect_to teams_path, notice: "Team delete"}
        format.json {render json: {team: @team, status: :ok}.to_json}
        format.js
      else
        format.html { redirect_to teams_path, error: "Failed to delete this team"}
        format.json {render json: {team: @team, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  #Obtener todos los equipos de un curso
  def find_teams_by_course
    @course = Course.find(params[:id])
    if @course == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end
    #Rails incluye algunos metodos para cada tipo de asociocion, una relación muchos a uno dispone del siguiente: 
    @teams = @course.teams #Asi obtengo todos los equipos relacionados con un curso en particular
    respond_to do |format|
      if @teams == nil
        format.html{redirect_to teams_path, notice: "Success"}
        format.json {render json: {teams: @teams, status: :ok}.to_json}
        format.js
      else
        format.html{redirect_to teams_path, error: "This course does not have teams"}
        format.json {render json: {teams: @teams, status: :ok}.to_json}
        format.js
      end
    end
  end

  #Obtener miembros de un equipo
  def find_members_by_team
    @team = Team.find(params[:id])
    @users = User.joins(:course_users).where(course_users: {team_id: @team.id})
  end

  #Obtener los equipos de un usuario
  def find_teams_by_user
    @user = User.find(params[:id])
    @teams = Team.joins(:course_users).where(course_users: {user_id: @user.id})
  end

  private

    def team_params
        params.require(:team).permit(:name,:description, :initials, :logo, :course_id)
    end
end
