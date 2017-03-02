class CoursesController < ApplicationController

  layout "dashboard"

  def index
    @course = Course.new
    @my_courses = Course.joins(:course_user_relationships).where(course_user_relationships: {user_id: current_user.id}).order('created_at DESC')
  end

  def show

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

  private

    def course_params
        params.require(:course).permit(:name, :description)
    end

  def edit
  end

  def update
  end

  def delete
  end
end
