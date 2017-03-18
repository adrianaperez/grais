class CoursesController < ApplicationController

  layout "base"

  #skip_before_action :verify_authenticity_token #esto es para hacer pruebas, preguntar antes si necesitas eliminarlo


  def index
    @course = Course.new
    @my_courses = Course.joins(:course_user_relationships).where(course_user_relationships: {user_id: current_user.id}).order('created_at DESC')
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
  end

  def create

    @course = Course.create(course_params)
    @course_user = CourseUserRelationship.new
    @course_user.user_category = "profesor"
    @course_user.user = current_user
    @course_user.course = @course

    #@course = Course.create(name:"curso", description:"primer curso")
    #@product = Product.create(name:"product", description:"product")
    #@company = Company.create(name:"company", product: @product)
    
    #@course_user = current_user.course_user_relationships.build(course:@course, company: @company,  user_category:"profesor")
    
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
    courses = Course.all
    
    puts courses.inspect

      respond_to do |format|
        format.json {render json: courses}
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
        cu = CourseUser.new(:user => u,:course => c,:rol => "L")

        if cu.save
          respond_to do |format|
            format.json {render json: c, status: :ok}
          end
        else
          respond_to do |format|
            format.json {render json:  {info: "Curso-Usuario no creado", status: :unprocessable_entity}.to_json}
          end
        end
      else
        respond_to do |format|
          format.json {render json: c, status: :unprocessable_entity}
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
            format.json {render json: c, status: :ok}
         end
      else
         respond_to do |format|
            format.json {render json: c, status: :unprocessable_entity}
         end
      end
   end

  #Obtener todos los cursos de un usuario
  def find_courses_by_user
    u = User.find(params[:id])
    if u == nil
        respond_to do |format|
          format.json {render json: u, status: :not_found}
        end
    end
    #comparar el id con el id_user que tenga la tabla course_usuario
    list = CourseUser.where(:user => u)
    
    if (list != nil)
      respond_to do |format|
        format.json {render json: list}
      end
    else
        respond_to do |format|
          format.json {render json: {info: "Unprocessable entity", status: :unprocessable_entity}.to_json}
        end
    end
  end

  #Obtener cursos dado un string
  def search_courses_by_string
    #listSearch = Course.where("name LIKE %?%", params[:name_course])
    listSearch = Course.where("name LIKE ?", "%#{params[:name_course]}%")
    puts  listSearch.inspect

    if (listSearch != nil)
      respond_to do |format|
        format.json {render json: listSearch}
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
