class CoursesController < ApplicationController

  layout :resolve_layout

  # Usado para comunicarse con el sistema de notificaciones
  require 'net/http'

  #skip_before_action :verify_authenticity_token #esto es para hacer pruebas, preguntar antes si necesitas eliminarlo


  def index
    @course = Course.new
    courses = Course.joins(:course_users).where(course_users: {user_id: current_user.id}).order('created_at DESC')
    @my_courses = Array.new
    courses.each do |course|
      c_u = CourseUser.where(course_id: course.id)
      course.studentsAmount = c_u.length - 1
      c_u.each do |cu|
        if cu.rol == "CEO"
          course.ceo = cu.user.names
          course.ceo_id = cu.user.id
        end
      end
      @my_courses << course
    end  
  end

  def show
    @course = Course.find(params[:id])
    @team = Team.new
  end

  def new
    @course = Course.new
  end

  def create

    @courses = Array.new
    for i in 1..(Integer(params[:course][:section]))
      @course = Course.new(course_params);
      @course.section = i
      if @course.save
        @course_user = CourseUser.new
        @course_user.rol = "CEO"
        @course_user.user = current_user
        @course_user.course = @course
        
        respond_to do |format|
          if @course_user.save
            @courses << @course
            format.html{redirect_to dashboard_path}
            format.js
          else
            format.html { render "new" }
            format.js
          end
        end
      else
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    
    respond_to do |format|
      if @course.update_attributes(course_params)
        format.html{redirect_to courses_path, notice: "Course was successfully updated"}
        format.json {render json:{team: @course, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to update this course"}
        format.json {render json: {info: "Failed to update this course", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @course = Course.find(params[:id])
    respond_to do |format|
      if @course.destroy
        format.html{redirect_to courses_path, notice: "Course delete"}
        format.json {render json: {info: "Course delete", status: :ok}.to_json}
        format.js
      else
        format.html { redirect_to courses_path, error: "Failed to delete this course"}
        format.json {render json: {info: "Failed to delete this course", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  # get all the courses
  def all
    list = Array.new

    Course.all.each do |course|
      auxList = CourseUser.where(:course => course) # Y para obtener el numero de miembros de ese curso, buscamos todos los registros
                                                    # en CourseUSer donde aparece dicho curso (miembros)
      course.studentsAmount = auxList.length - 1

      #Esta variable es una bandera para saber si el usuario es miembro o no, si es que nos lo pasan
      is_member = false

      # Encontrar el CEO del curso en el cual aparece el usuario
      # Buscar el registro del CEO en la lista de registros en CourseUSer donde aparece dicho curso (miembros)
      auxList.each do |auxCU|  
        if auxCU.rol == "CEO" # Es decir donde el rol es CEO
          course.ceo = auxCU.user.names + " " + auxCU.user.lastnames
          course.ceo_id = auxCU.user.id
        end

        # si nos pasan el id de usuario, lo comparamos con cada miembro, y si lo conseguimos ponemos
        # la bandera en true
        if(params[:user_id] != nil and auxCU.user.id == Integer(params[:user_id]))
          is_member = true;
        end
      end

      course.is_member = is_member

      list << course
    end

    if (list != nil)
      @courses_list = list
      respond_to do |format|
        format.json {render json: {courses: list, status: :ok}.to_json}
        format.js
      end
    else
      respond_to do |format|
        format.json {render json: {info: "Unprocessable entity", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  #create 1 course
  def create_course

    u = User.find(params[:user_id])
    #verificando que el usuario existe
    if u == nil
      respond_to do |format|
        format.json {render json:  {info: "Not found user", status: :not_found}.to_json}
      end
    end

    created_courses = Array.new
    
    for i in 0..(Integer(params[:section]) - 1)
      c = Course.new
      c.name = params[:name]
      c.initials = params[:initials]
      c.period_type = params[:period_type]
      c.section = i+1
      c.category = params[:category]
      c.institute = params[:institute]
      c.content = params[:content]
      c.privacy = params[:privacy]
      c.inscriptions_activated = params[:inscriptions_activated]
      c.evaluate_teacher = params[:evaluate_teacher]
      c.strict_mode_isa = params[:strict_mode_isa]
      c.code_confirmed = params[:code_confirmed]
      c.logo = "489563.png"
      c.period_length = params[:period_length]
      c.description = params[:description]

      if c.save
        cu = CourseUser.new(:user => u,:course => c,:rol => "CEO")

        if cu.save
          created_courses << c
          next
        else
          respond_to do |format|
            format.json {render json:  {info: "Curso-Usuario no creado", course: c, status: :unprocessable_entity}.to_json}
          end
        end
      else
        respond_to do |format|
          format.json  {render json: {course: c, status: :unprocessable_entity}.to_json}
        end
      end
    end #for

    respond_to do |format|

      format.json {render json: {course: created_courses, status: :ok}.to_json} ### revisar, se cambio el nombre a plural
    end
  end  #action

   #update 1 course
  def update_course
    c = Course.find(params[:id])

    if c == nil
      respond_to do |format|
        format.json {render json: c, status: :not_found}
      end
    end

    c.name = params[:name]
    c.initials = params[:initials]
    c.period_type = params[:period_type]
    c.section = params[:section]
    c.category = params[:category]
    c.institute = params[:institute]
    c.content = params[:content]
    c.privacy = params[:privacy]
    c.inscriptions_activated = params[:inscriptions_activated]
    c.evaluate_teacher = params[:evaluate_teacher]
    c.strict_mode_isa = params[:strict_mode_isa]
    c.code_confirmed = params[:code_confirmed]
    c.logo = "489563.png"
    c.period_length = params[:period_length]
    c.description = params[:description]

    if c.save
      respond_to do |format|

        format.json {render json: {course: c, status: :ok}.to_json}
      end
    else
      respond_to do |format|
        format.json  {render json: {course: c, status: :unprocessable_entity}.to_json}
      end
    end
  end

  #Obtener todos los cursos de un usuario
  def find_courses_by_user
    u = User.find(params[:id])
    if u == nil
      respond_to do |format|
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
      end
    end

    list = Array.new

    #Buscar los registros de CourseUSer de el usuario (u)
    CourseUser.where(:user => u).each do |cu|   # Para cada registro en el que aparece el usuario
      course = cu.course  #Course.find(cu.course.id)  # Obtener el curso
      auxList = CourseUser.where(:course => course) # Y para obtener el numero de miembros de ese curso, buscamos todos los registros
                                                    # en CourseUSer donde aparece dicho curso (miembros)
      course.studentsAmount = auxList.length - 1

      # Encontrar el CEO del curso en el cual aparece el usuario
      if cu.rol == "CEO"  #Dado que estos registros de CourseUser son de el usuario actual, si el rol es CEO implica que u es el CEO
        course.ceo = u.names + " " + u.lastnames
        course.ceo_id = u.id
      else  # Buscar el registro del CEO en la lista de registros en CourseUSer donde aparece dicho curso (miembros)
        auxList.each do |auxCU|  
          if auxCU.rol == "CEO" # Es decir donde el rol es CEO
            course.ceo = auxCU.user.names + " " + auxCU.user.lastnames
            course.ceo_id = auxCU.user.id
          end
        end
      end

      course.is_member = true

      list << course
    end
    
    if (list != nil)
      respond_to do |format|
        format.json {render json: {courses: list, status: :ok}.to_json}
      end
    else
      respond_to do |format|
        format.json {render json: {info: "Unprocessable entity", status: :unprocessable_entity}.to_json}
      end
    end
  end

  #Obtener cursos dado un string
  def search_courses_by_string
    list = Array.new()
    listSearch = Course.where("name LIKE ?", "%#{params[:name_course]}%")
    listSearch.each do |course| #Buscar cursos dado el nombre del curso
      auxList = CourseUser.where(:course => course) # Y para obtener el numero de miembros de ese curso, buscamos todos los registros
                                                    # en CourseUSer donde aparece dicho curso (miembros)
      course.studentsAmount = auxList.length - 1     # El menos uno es para no inluir a quien creo el curso                                               

      is_member = false

      # Encontrar el CEO del curso en el cual aparece el usuario
      # Buscar el registro del CEO en la lista de registros en CourseUSer donde aparece dicho curso (miembros)
      auxList.each do |auxCU|
        if auxCU.rol == "CEO"
          course.ceo = auxCU.user.names + " " + auxCU.user.lastnames
          course.ceo_id = auxCU.user.id 
        end

        #Pasar el user_id para saber si es miembro o no
        if (params[:user_id] != nil && Integer(params[:user_id]) == auxCU.user_id)
          is_member = true
        end
      end

      course.is_member = is_member
      list << course
    end

    puts list.inspect
    if (list != nil)
      respond_to do |format|
        format.json {render json: {courses: list, status: :ok}.to_json}
      end
    else
      respond_to do |format|
        format.json {render json: {info: "Unprocessable entity", status: :unprocessable_entity}.to_json}
      end
    end
  end

  def request_course_access

    user = User.find(params[:user_id])

    if user == nil
      respond_to do |format|
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
      end
    end

    course = Course.find(params[:course_id])

    if course == nil
      respond_to do |format|
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
      end
    else
      c_u = CourseUser.where(course_id: course.id)
      c_u.each do |cu|
        if cu.rol == "CEO"
          course.ceo = cu.user.names + " " + cu.user.lastnames
          course.ceo_id = cu.user.id
        end
      end

      ##############################
      tokens = FcmToken.where(:user_id => course.ceo_id)

      if tokens.length > 0 && tokens[0] != nil
        respond_to do |format|
          format.json {render json: {info: "Request sended", status: :ok}.to_json}
        end
        
        #Prueba: Manejo de notificaciones
        uri = URI('https://fcm.googleapis.com/fcm/send')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})
        # AVD: csl75XXovhw:APA91bFrxbFQqHx2E7O_bfP9fbwwTdtrVbFcdGHDGQ1PILQ8IysP4CyW5-krQoOo4dNb3eMpvxvscrRAL1axZ7h6t6k17BMbIs65aj1deBlQWbc3doftupO1FDzwafh028xodkmLV8E-
        # phone: fzMWjdyf0js:APA91bGL7_fX6tauaBlv2GelJEwOPTZdf9mzwNcSgGNn_73JocPGTGuqXTelk4gsRL-yf-ro9YrCzRVAY_0L2kEZzt7xF3Lx3spYLg-uiMBXDio97NgScpstU6Na52sBAcq4qDoykb4d

        req.body = {:to => tokens[0].token,
         :notification => {:title => 'Nueva solicitud de ingreso a tu curso', :body => user.names + ' ha solicitado unirse a tu curso: ' + course.name},
          :data => {:type => 'NEW_COURSE_MEMBER', :user_id => user.id, :user_name => user.names, :course_id => course.id, :course_name => course.name}}.to_json

        response = http.request(req)
        ##############################

      else
        respond_to do |format|
          format.json {render json: {info: "There is no device for this user", status: :unprocessable_entity}.to_json}
        end
      end
    end
  end

  #Agregar miembros a un curso
  def add_member_to_course
    user = User.find(params[:user_id])

    if user == nil
      respond_to do |format|
        format.json {render json: {info: "User not found", status: :not_found}.to_json}
      end
    end

    course = Course.find(params[:course_id])

    if course == nil
      respond_to do |format|
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
      end
    end

    course_user = CourseUser.where("user_id = ? AND course_id = ?", user.id, course.id)

    if course_user.any?
        respond_to do |format|
          format.json {render json: {info: "The user is already a member", status: :unprocessable_entity}.to_json}
        end
    else
      course_user = CourseUser.new
      course_user.user = user
      course_user.course = course
      course_user.rol = "MEMBER"

      if course_user.save
        respond_to do |format|
          format.json {render json:  {info: "User added to the course", course_user: course_user, status: :ok}.to_json}
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
           :notification => {:title => 'Tu solicitud de acceso ha sido aprobada!', :body => 'Has sido aceptada tu solicitud, ya eres parte del curso: ' + course.name},
            :data => {:type => 'ACCEPTED_IN_COURSE', :user_id => user.id, :user_name => user.names, :course_id => course.id, :course_name => course.name}}.to_json

          response = http.request(req)
          ##############################
        end
      else
        respond_to do |format|
          format.json {render json: { info: "Failed to create course_user",  status: :unprocessable_entity}.to_json}
        end
      end
    end
  end

  #Obtener miembros de un curso
  def find_members_by_course
    course = Course.find(params[:id])

    if course == nil
      respond_to do |format|
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
      end
    end

    course_users = CourseUser.where(:course => course)

    course_users.each do |cu| #Pasando campos necesarios para armar la lista de los miembros
      cu.names_user = cu.user.names
      cu.lastnames_user = cu.user.lastnames
      cu.image_user = cu.user.image_user
      if cu.team != nil
        cu.name_team = cu.team.name
      end 
    end    

    respond_to do |format|
      format.json {render json: {course_users: course_users, status: :ok}.to_json}
    end
  end


  # Se coloco al final para que no de peos con las acciones de la app, tambien se agrego los campos faltantes
  private

    def course_params
        params.require(:course).permit(:name,:initials,:period_type,:section,:category,:institute,:content,:privacy,:inscriptions_activated,:evaluate_teacher,
        :strict_mode_isa,:code_confirmed,:logo,:period_length,:description)
    end

    def resolve_layout
      case action_name
      when "show"
        "main"
      when "index"
        "main"
      else
        "application"
      end
    end
end
