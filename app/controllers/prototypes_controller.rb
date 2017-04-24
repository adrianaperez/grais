class PrototypesController < ApplicationController

	def create_prototype
    prototype = Prototype.new();
    prototype.name = params[:name]
    prototype.description = params[:description]
    prototype.logo = params[:logo]
    prototype.course_id = params[:course_id]
    prototype.initials = params[:initials]

    respond_to do |format|
      if prototype.save
        format.json {render json: {prototype: prototype, status: :ok}.to_json}
      else
      end
    end
	end

	def update_prototype
    prototype = Prototype.find(params[:id])
    prototype.name = params[:name]
    prototype.description = params[:description]
    prototype.logo = params[:logo]
    prototype.initials = params[:initials]

    respond_to do |format|
      if prototype.save
        format.json {render json: {prototype: prototype, status: :ok}.to_json}
      else
        format.json {render json: {prototype: prototype, status: :unprocessable_entity}.to_json}
      end
    end
	end

	def find_by_course
	    course = Course.find(params[:id])

	    if course == nil
	      respond_to do |format|
	        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
	      end
	    end

	    prototypes = course.prototypes

	    respond_to do |format|
	      format.json {render json: {prototypes: prototypes, status: :ok}.to_json}
	    end
	end

end
