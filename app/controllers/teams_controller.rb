class TeamsController < ApplicationController

  layout "main"

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    @product = Product.new
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params);
    @course_users = CourseUser.where("user_id = ? AND course_id = ?", params[:team][:user_id], params[:team][:course_id])
    @error = 0

    if @course_users.any?

      @course_user = @course_users.first
      if @course_user.team_id == nil
        
        if @team.save
          @course_user.rol = "LEADER"
          @course_user.team_id = @team.id
          if @course_user.save
            @team.studentsAmount = 1
            @team.leader = @course_user.user.names
            @team.leader_id = @course_user.user.id
            respond_to do |format|
              if @team.save
                format.js
              else
                format.js
              end
            end
          else
            #@team.destroy #Creo que deberia ir en caso de que no se pueda establecer la asociación
            respond_to do |format|
              format.js
            end
          end
        else
          respond_to do |format|
            format.html { render "new", error: "The team was not created" }
            format.js
          end
        end  
      else
        @error=1
      end
    else
      @error=1
    end
  end

  def create_team
    #Se necesita el id del curso,
    #yo lo puedo pasar desde el formulario como hidden
    #el id del usuario, user_id, se debe pasar en el post como un campo mas del objeto
    @team = Team.new();
    #Del objeto completo que se pasa en el post "team" (con sus respectivos campos + user_id)", obtengo los campos del Team
    @team.name = params[:team][:name]
    @team.description = params[:team][:description]
    @team.initials = params[:team][:initials]
    @team.logo = params[:team][:logo]
    @team.course_id = params[:team][:course_id]

    course_users = CourseUser.where("user_id = ? AND course_id = ?", params[:team][:user_id], params[:team][:course_id])
  
    #Como se supone que hay un solo course_user en que coincidan usuario y curso, obtenemos el primer elemento
    course_user = course_users[0]

    if course_user.team_id == nil
      if @team.save
        course_user.rol = "LEADER"
        course_user.team_id = @team.id
            
        if course_user.save
          # Notificar al ceo  
          c_u = CourseUser.where(course_id: course_user.course.id)
          c_u.each do |cu|
            if cu.rol == "CEO"
              ##############################
              tokens = FcmToken.where(:user_id => cu.user.id)

              if tokens.length > 0 && tokens[0] != nil
                uri = URI('https://fcm.googleapis.com/fcm/send')
                http = Net::HTTP.new(uri.host, uri.port)
                http.use_ssl = true
                req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})

                req.body = {:to => tokens[0].token,
                 :notification => {:title => 'Se ha creado un equipo en tu curso', :body => course_user.user.names + ' ha creado en ' + course_user.course.name + ' el equipo: ' + @team.name},
                  :data => {:type => 'NEW_TEAM_CREATED', :user_id => course_user.user.id, :user_name => course_user.user.names, :course_id => course_user.course.id, :course_name => course_user.course.name, :team_id => @team.id, :team_name => @team.name}}.to_json

                response = http.request(req)
                ##############################
              end
            end
          end

          respond_to do |format|
            format.json {render json:  {course_user: course_user, status: :ok}.to_json}
          end
        else
          respond_to do |format|
            format.json {render json: { info: "Failed to create course_user",  status: :bad_request}.to_json}
          end
        end
      else
        respond_to do |format|
          format.html { render "new", error: "Failed to create team" }
          format.json {render json: { info: "Failed to create team",  status: :unprocessable_entity}.to_json}
          format.js
        end
      end
    else
      respond_to do |format|
        format.json {render json: {info: "The user already have a team in this course", status: :bad_request}.to_json}
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
        format.html { render "edit", error: "Failed to update this team"}
        format.json {render json: {info: "Failed to update this team", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    respond_to do |format|
      if @team.destroy
        format.html{redirect_to teams_path, notice: "Team delete"}
        format.json {render json: {info: "Team delete", status: :ok}.to_json}
        format.js
      else
        format.html { redirect_to teams_path, error: "Failed to delete this team"}
        format.json {render json: {info: "Failed to delete this team", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end


  def request_team_access

    user = User.find(params[:user_id])

    if user == nil
      respond_to do |format|
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
      end
    end

    team = Team.find(params[:team_id])

    if team == nil
      respond_to do |format|
        format.json {render json: {info: "Team not found", status: :not_found}.to_json}
      end
    else

      #Buscar el curso_user de ese usuario y el curso de ese equipo, deberia devolver nulo en el team_id
      course_user = CourseUser.where("user_id = ? AND course_id = ?", user.id, team.course.id)
      if course_user[0].team_id != nil
        respond_to do |format|
          format.json {render json: {info: "The user already have a team in this course", status: :bad_request}.to_json}
        end
      else
        leader_id = 0
        c_u = CourseUser.where(team_id: team.id)
        c_u.each do |cu|
          if cu.rol == "LEADER"
            leader_id = cu.user.id
          end
        end

        ##############################
        tokens = FcmToken.where(:user_id => leader_id)

        if tokens.length > 0 && tokens[0] != nil
          #Prueba: Manejo de notificaciones
          uri = URI('https://fcm.googleapis.com/fcm/send')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})
          # AVD: csl75XXovhw:APA91bFrxbFQqHx2E7O_bfP9fbwwTdtrVbFcdGHDGQ1PILQ8IysP4CyW5-krQoOo4dNb3eMpvxvscrRAL1axZ7h6t6k17BMbIs65aj1deBlQWbc3doftupO1FDzwafh028xodkmLV8E-
          # phone: fzMWjdyf0js:APA91bGL7_fX6tauaBlv2GelJEwOPTZdf9mzwNcSgGNn_73JocPGTGuqXTelk4gsRL-yf-ro9YrCzRVAY_0L2kEZzt7xF3Lx3spYLg-uiMBXDio97NgScpstU6Na52sBAcq4qDoykb4d

          req.body = {:to => tokens[0].token,
           :notification => {:title => 'Nueva solicitud de ingreso a tu equipo', :body => user.names + ' ha solicitado unirse a tu equipo: ' + team.name},
            :data => {:type => 'NEW_TEAM_MEMBER', :user_id => user.id, :user_name => user.names, :course_id => team.course.id, :team_id => team.id, :team_name => team.name}}.to_json

          response = http.request(req)
          ##############################

          respond_to do |format|
            format.json {render json: {info: "Request sended", status: :ok}.to_json}
          end
        else
          respond_to do |format|
            format.json {render json: {info: "There is no device for this user", status: :unprocessable_entity}.to_json}
          end
        end
      end
    end
  end

  def add_member_to_team
    #Necesito id del equipo y id del usuario
    user = User.find(params[:user_id])
    
    if user == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "User not found"}
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
        format.js
      end
    end

    team = Team.find(params[:team_id])
    
    if team == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Team not found"}
        format.json {render json: {info: "Team not found", status: :not_found}.to_json}
        format.js
      end
    end
    
    course = team.course
    
    course_user = CourseUser.where("user_id = ? AND course_id = ?", user.id, course.id)

    if course_user.any?
      # Validar si el usuario ya tiene un equipo en este curso
      if course_user[0].team_id != nil    
        respond_to do |format|
          format.html{redirect_to team_path, notice: "Success"}
          format.json {render json: {info: "This user is member of another team in this course", course_user: course_user, status: :expectation_failed}.to_json}
          format.js
        end
      else
        course_user.each do |cu|  #Aca entrara una sola vez! No hace falta un .each
          cu.rol = "MEMBER"
          cu.team = team
          if cu.save
            respond_to do |format|
              format.html{redirect_to team_path, notice: "Success"}
              format.json {render json: {course_user: course_user, status: :ok}.to_json}
              format.js
            end

            ##############################
            tokens = FcmToken.where(:user_id => user.id)

            if tokens.length > 0 && tokens[0] != nil
              #Prueba: Manejo de notificaciones
              uri = URI('https://fcm.googleapis.com/fcm/send')
              http = Net::HTTP.new(uri.host, uri.port)
              http.use_ssl = true
              req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})
              # AVD: csl75XXovhw:APA91bFrxbFQqHx2E7O_bfP9fbwwTdtrVbFcdGHDGQ1PILQ8IysP4CyW5-krQoOo4dNb3eMpvxvscrRAL1axZ7h6t6k17BMbIs65aj1deBlQWbc3doftupO1FDzwafh028xodkmLV8E-
              # phone: fzMWjdyf0js:APA91bGL7_fX6tauaBlv2GelJEwOPTZdf9mzwNcSgGNn_73JocPGTGuqXTelk4gsRL-yf-ro9YrCzRVAY_0L2kEZzt7xF3Lx3spYLg-uiMBXDio97NgScpstU6Na52sBAcq4qDoykb4d

              req.body = {:to => tokens[0].token,
               :notification => {:title => 'Tu solicitud de acceso ha sido aprobada!', :body => 'Has sido aceptada tu solicitud, ya eres parte del equipo: ' + team.name},
                :data => {:type => 'ACCEPTED_IN_TEAM', :user_id => user.id, :user_name => user.names, :team_id => team.id, :team_name => team.name}}.to_json

              response = http.request(req)
              ##############################
            end
          else  # CourseUser no actualizado, no se pudo asociar el usuario al curso
            respond_to do |format|
              format.html{redirect_to team_path, notice: "Course user not updated"}
              format.json {render json: {info: "Course user not updated", status: :bad_request}.to_json}
              format.js
            end
          end
        end
      end
    else  # Error, el usuario no pertenece al curso
      respond_to do |format|
        format.html{redirect_to team_path, notice: "The user is not member of this course"}
        format.json {render json: {info: "The user is not member of the course", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def delete_member
    #Necesito id del usuario y id del equipo
    user = User.find(params[:user_id])

    if user == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "User not found"}
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
        format.js
      end
    end

    team = Team.find(params[:team_id])

    if team == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Team not found"}
        format.json {render json: {info: "Team not found", status: :not_found}.to_json}
        format.js
      end
    end

    course = team.course
    course_user = CourseUser.where("user_id = ? AND course_id = ?", user.id, course.id)

    if course_user.any? # != nil
      course_user.each do |cu|
        cu.team = nil
        if cu.save
          respond_to do |format|
            format.html{redirect_to team_path, notice: "Success"}
            format.json {render json: {info: "Success", status: :ok}.to_json}
            format.js
          end
        else
          respond_to do |format|
            format.html{redirect_to team_path, notice: "not found"}
            format.json {render json: {info: "not found", status: :not_found}.to_json}
            format.js
          end
        end
      end
    else  # Error, el usuario no pertenece al curso
      respond_to do |format|
        format.html{redirect_to team_path, notice: "The user is not member of this course"}
        format.json {render json: {info: "The user is not member of the course", status: :unprocessable_entity}.to_json}
        format.js
      end     
    end
  end

  #Obtener todos los equipos de un curso
  def find_teams_by_course 
    course = Course.find(params[:id])

    if course == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end

    #Rails incluye algunos metodos para cada tipo de asociocion, una relación muchos a uno dispone del siguiente: 
    teams = course.teams #Asi obtengo todos los equipos relacionados con un curso en particular
    @team_list = Array.new

    if teams.any?
      teams.each do |team|
        aux_list = CourseUser.where(team_id: team.id)

        if aux_list.any?
          aux_list.each do |auxCU|  
            if auxCU.rol == "LEADER" # Es decir donde el rol es lider
              team.leader = auxCU.user.names + " " + auxCU.user.lastnames
              team.leader_id = auxCU.user.id
            end
          end
          team.studentsAmount = aux_list.length

          @team_list << team
        end
      end
    end

    respond_to do |format|
      format.html{redirect_to teams_path, notice: "Success"}
      format.json {render json: {teams: @team_list, status: :ok}.to_json}
      format.js
    end
  end

  #Obtener miembros de un equipo
  def find_members_by_team
    team = Team.find(params[:id])

    if team == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Team not found"}
        format.json {render json: {info: "Team not found", status: :not_found}.to_json}
        format.js
      end
    end

    @users = User.joins(:course_users).where(course_users: {team_id: team.id})

    @users.each do |u|
      course_users = CourseUser.where("user_id = ? AND course_id = ?", u.id, team.course.id)
      
      course_user = course_users[0]

      u.rol = course_user.rol
    end
  
    respond_to do |format|
      format.html{redirect_to teams_path, notice: "Success"}
      format.json {render json: {users: @users, status: :ok}.to_json}
      format.js
    end
  end

  #Obtener los equipos de un usuario
  def find_teams_by_user
    user = User.find(params[:id])
    
    if user == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "User not found"}
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
        format.js
      end
    end

    @teams = Team.joins(:course_users).where(course_users: {user_id: user.id})

    if @teams.any?
      @teams.each do |team|
        aux_list = CourseUser.where(team_id: team.id)

        if aux_list.any?
          aux_list.each do |auxCU|  
            if auxCU.rol == "LEADER" # Es decir donde el rol es lider
              team.leader = auxCU.user.names + " " + auxCU.user.lastnames
              team.leader_id = auxCU.user.id
            end
          end

          team.studentsAmount = aux_list.length
        end
      end
    end

    respond_to do |format|
      format.html{redirect_to teams_path, notice: "Success"}
      format.json {render json: {teams: @teams, status: :ok}.to_json}
      format.js
    end
  end

  def update_team
    @team = Team.find(params[:team][:id])
    
    respond_to do |format|
      if @team.update_attributes(team_params)
        format.json {render json:{team: @team, status: :ok}.to_json}
      else
        format.json {render json: {info: "Failed to update this team", status: :unprocessable_entity}.to_json}
      end
    end
  end

  private

    def team_params
        params.require(:team).permit(:name, :description, :initials, :logo, :course_id)
    end
end
