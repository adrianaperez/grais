class CoursesController < ApplicationController

  layout "base"

  #skip_before_action :verify_authenticity_token #esto es para hacer pruebas, preguntar antes si necesitas eliminarlo


  def index
    @course = Course.new
    @my_courses = Course.joins(:course_users).where(course_users: {user_id: current_user.id}).order('created_at DESC')
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
  end

  def create

    @course = Course.create(course_params)
    @course_user = CourseUser.new
    @course_user.rol = "CEO"
    @course_user.user = current_user
    @course_user.course = @course
    
    respond_to do |format|
      if @course_user.save
        format.html{redirect_to dashboard_path}
        format.js
      else
        format.html { render "new" }
        format.js
      end
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
  end

  def delete
  end

  # get all the courses
  def all
    list = Array.new

    Course.all.each do |course|
      auxList = CourseUser.where(:course => course) # Y para obtener el numero de miembros de ese curso, buscamos todos los registros
                                                    # en CourseUSer donde aparece dicho curso (miembros)
      course.studentsAmount = auxList.length - 1

      # Encontrar el CEO del curso en el cual aparece el usuario
      # Buscar el registro del CEO en la lista de registros en CourseUSer donde aparece dicho curso (miembros)
      auxList.each do |auxCU|  
        if auxCU.rol == "CEO" # Es decir donde el rol es CEO
          course.ceo = auxCU.user.names
          course.ceo_id = auxCU.user.id
        end
      end

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

  #create 1 course
  def create_course

      u = User.find(params[:user_id])
      #verificando que el usuario existe
      if u == nil
        respond_to do |format|
          format.json {render json:  {info: "Not found user", status: :not_found}.to_json}
        end
      end

      c = Course.new
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
        cu = CourseUser.new(:user => u,:course => c,:rol => "CEO")

        if cu.save
          respond_to do |format|

            format.json {render json: {course: c, status: :ok}.to_json}
          end
        else
          respond_to do |format|
            format.json {render json:  {info: "Curso-Usuario no creado", status: :unprocessable_entity}.to_json}
          end
        end
      else
        respond_to do |format|

          format.json  {render json: {course: c, status: :unprocessable_entity}.to_json}
        end
      end

     
   end

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
        course.ceo = u.names
        course.ceo_id = u.id
      else  # Buscar el registro del CEO en la lista de registros en CourseUSer donde aparece dicho curso (miembros)
        auxList.each do |auxCU|  
          if auxCU.rol == "CEO" # Es decir donde el rol es CEO
            course.ceo = auxCU.user.names
            course.ceo_id = auxCU.user.id
          end
        end
      end

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
      puts course.inspect
      puts auxList.length
      course.studentsAmount = auxList.length - 1     # El menos uno es para no inluir a quien creo el curso                                               
    
      # Encontrar el CEO del curso en el cual aparece el usuario
      # Buscar el registro del CEO en la lista de registros en CourseUSer donde aparece dicho curso (miembros)
      auxList.each do |auxCU|
        if auxCU.rol == "CEO"
          course.ceo = auxCU.user.names
          course.ceo_id = auxCU.user.id 
        end
      end

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

  # Se coloco al final para que no de peos con las acciones de la app, tambien se agrego los campos faltantes
  private

    def course_params
        params.require(:course).permit(:name,:initials,:period_type,:section,:category,:institute,:content,:privacy,:inscriptions_activated,:evaluate_teacher,
        :strict_mode_isa,:code_confirmed,:logo,:period_length,:description)
    end

end
