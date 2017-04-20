class TasksController < ApplicationController
	def create_task
		task = Task.new()
		task.description = params[:description]
		task.execution = 0
		task.commitment = Commitment.find(params[:commitment_id])
		task.user = User.find(params[:user_id])	
    task.due_date = params[:due_date]	

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
	 			#Notificar al usuario al que le fue asignada la tarea 
      	##############################
      	tokens = FcmToken.where(:user_id => task.user.id)

      	if tokens.length > 0 && tokens[0] != nil
        	uri = URI('https://fcm.googleapis.com/fcm/send')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})

          req.body = {:to => tokens[0].token,
           :notification => {:title => 'Se ha creado una tarea para ti', :body => task.user.names + ' te ha asignado la siguiente tarea: ' + task.description},
            :data => {:type => 'NEW_TASK', :user_id => task.user.id, :user_name => task.user.names, :task_id => task.id, :task_desc => task.description, :commitment_id => task.commitment.id}}.to_json

          response = http.request(req)
          ##############################
      	end
    	
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
    task.user = User.find(params[:user_id]) 

  	if task == nil
	  	respond_to do |format|
	    	format.json {render json:  {info: "Task not found", status: :not_found}.to_json}
	  	end
  	else
      if task.save
  			#Notificar al usuario al que le fue asignada la tarea 
      	##############################
      	tokens = FcmToken.where(:user_id => task.user.id)

      	if tokens.length > 0 && tokens[0] != nil
        	uri = URI('https://fcm.googleapis.com/fcm/send')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})

          req.body = {:to => tokens[0].token,
           :notification => {:title => 'Se ha editado una de tus tareas', :body => 'Ahora tu tarea es: ' + task.description},
            :data => {:type => 'TASK_UPDATE', :user_id => task.user.id, :user_name => task.user.names, :task_id => task.id, :task_desc => task.description, :commitment_id => task.commitment.id}}.to_json

          response = http.request(req)
          ##############################
      	end

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
			c.user_name = c.user.names + " "+ c.user.lastnames
		end

  	respond_to do |format|
      format.json {render json: { tasks: tasks,  status: :ok}.to_json}
  	end
	end
end
