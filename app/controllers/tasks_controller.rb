class TasksController < ApplicationController
	def create_task
		task = Task.new()
		task.description = params[:description]
		task.execution = 0
		task.commitment = Commitment.find(params[:commitment_id])
		task.user = User.find(params[:user_id])		

		if task.user == nil
	        respond_to do |format|
	            format.json {render json: { info: "User not found",  status: :not_found}.to_json}
	        end
      	elsif task.commitment == nil
          	respond_to do |format|
            	format.json {render json: { info: "Commitment not found",  status: :not_found}.to_json}
          	end
        else
	        if task.save
	          	respond_to do |format|
	            	format.json {render json:  {task: task, status: :ok}.to_json}
	          	end
	        else
	          	respond_to do |format|
	            	format.json {render json: { info: "Error creating task",  status: :unprocessable_entity}.to_json}
	          	end
	        end
	    end
	end

	def update_task
		task = Task.find(params[:id])
		task.description = params[:description]
		task.execution = params[:execution]

    	if task == nil
		  	respond_to do |format|
		    	format.json {render json:  {info: "Task not found", status: :not_found}.to_json}
		  	end
	  	else
	        if task.save
	          	respond_to do |format|
	            	format.json {render json:  {task: task, status: :ok}.to_json}
	          	end
	        else
	          	respond_to do |format|
	            	format.json {render json: { info: "Error updating task",  status: :unprocessable_entity}.to_json}
	          	end
	        end
	    end
	end

	def find_by_user
		tasks = Task.where( user_id: params[:user_id])

		tasks.each do |c|
			c.user_name = c.user.names
		end

      	respond_to do |format|
	        format.json {render json: { tasks: tasks,  status: :ok}.to_json}
      	end
	end

	def find_by_commitment
		tasks = Task.where( commitment_id: params[:commitment_id])

		tasks.each do |c|
			c.user_name = c.user.names
		end

      	respond_to do |format|
	        format.json {render json: { tasks: tasks,  status: :ok}.to_json}
      	end
	end
end
