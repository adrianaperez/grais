class TasksAbstractsController < ApplicationController

	def create
		@abstract = TasksAbstract.new(tasks_abstract_params);
		@abstract.save
		respond_to do |format|
			format.js
		end
	end

	def update
		@abstract = TasksAbstract.find(params[:id])
		@abstract.update_attributes(tasks_abstract_params)
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@abstract = TasksAbstract.find(params[:id])
		@abstract.destroy
		respond_to do |format|
			format.js
		end
	end

	def create_task_abstract
		abstract = TasksAbstract.new()
		abstract.abstract = params[:abstract]
		abstract.task = Task.find(params[:task_id])

		if abstract.task == nil
	     	respond_to do |format|
	        	format.json {render json: { info: "Task not found",  status: :not_found}.to_json}
  			end
	    else
    	  	if abstract.save

		    	respond_to do |format|
		      		format.json {render json:  {abstract: abstract, status: :ok}.to_json}
		    	end
    	  	else

		      	respond_to do |format|
		        	format.json {render json: { info: "Error creating abstract",  status: :unprocessable_entity}.to_json}
		      	end
    	  	end
    	end
    end

	def update_task_abstract
		abstract = TasksAbstract.find(params[:id])
		abstract.abstract = params[:abstract]

	  	if abstract == nil
		  	respond_to do |format|
		    	format.json {render json:  {info: "Abstract not found", status: :not_found}.to_json}
		  	end
	  	else
	    	if abstract.save
		      	respond_to do |format|
		        	format.json {render json:  {abstract: abstract, status: :ok}.to_json}
		      	end
	    	else
		      	respond_to do |format|
		        	format.json {render json: { info: "Error updating abstract",  status: :unprocessable_entity}.to_json}
		      	end
	     	end
	    end
	 end

	def find_by_user
		tasks = Task.where( user_id: params[:user_id])

		abstracts = Array.new

		tasks.each do |t|
			if t.tasks_abstract
				abstracts << t.tasks_abstract
			end
		end

	  	respond_to do |format|
	      format.json {render json: { abstracts: abstracts,  status: :ok}.to_json}
	  	end
	end

	def find_by_task
		task = Task.find(params[:task_id])

	  	respond_to do |format|
	      format.json {render json: { abstract: task.tasks_abstract,  status: :ok}.to_json}
  		end
	end

	private

    def tasks_abstract_params
        params.require(:tasks_abstract).permit(:abstract, :task_id)
    end
end
