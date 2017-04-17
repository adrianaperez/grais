class CommitmentsController < ApplicationController

	def create_commitment
    	commitment = Commitment.new()
    	commitment.description = params[:description]
    	commitment.deadline = params[:deadline]
    	commitment.execution = 0
    	commitment.count = 0

    	currUser = User.find(params[:user_id])
    	commitment.user = currUser.id
    	commitment.product = Product.find(params[:product_id])


    	# validate if the user and the product were found
    	if currUser == nil
	        respond_to do |format|
	            format.json {render json: { info: "User not found",  status: :not_found}.to_json}
	        end
      	elsif commitment.product == nil
          	respond_to do |format|
            	format.json {render json: { info: "Product not found",  status: :not_found}.to_json}
          	end
        else
        	#commitment.user = commitment.user.id
	        if commitment.save
	        	# Notificar a todo el resto del equipo
	          	c_u = CourseUser.where(course_id: commitment.product.team.course.id)
	          	c_u.each do |cu|
		            if ((cu.user_id != currUser.id && cu.team_id == commitment.product.team.id) || cu.rol == "CEO")
		              	##############################
		              	tokens = FcmToken.where(:user_id => cu.user_id)

		              	if tokens.length > 0 && tokens[0] != nil
			                uri = URI('https://fcm.googleapis.com/fcm/send')
			                http = Net::HTTP.new(uri.host, uri.port)
			                http.use_ssl = true
			                req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})

			                req.body = {:to => tokens[0].token,
			                 :notification => {:title => 'Han creado un compromiso en uno de tus equipos', :body => currUser.names + ' ha creado un compromiso en el equipo ' + commitment.product.team.name + ' del curso ' + cu.course.name},
			                  :data => {:type => 'NEW_COMMITMENT', :commitment_id => commitment.id, :commitment_desc => commitment.description,:user_id => currUser.id, :user_name => currUser.names, :course_id => cu.course.id, :course_name => cu.course.name, :team_id => commitment.product.team.id, :team_name => commitment.product.team.name}}.to_json

			                response = http.request(req)
			                ##############################
	              		end
		            end
	          	end

	          	respond_to do |format|
	            	format.json {render json:  {commitment: commitment, status: :ok}.to_json}
	          	end
	        else
	          	respond_to do |format|
	            	format.json {render json: { info: "Error creating commitment",  status: :unprocessable_entity}.to_json}
	          	end
	        end
	    end
	end

	def update_commitment
    	commitment = Commitment.find(params[:id])

    	# validate if the commitment was found
    	if commitment == nil
		  	respond_to do |format|
		    	format.json {render json:  {info: "Commitment not found", status: :not_found}.to_json}
		  	end
	  	else
	    	commitment.description = params[:description]
	    	
	    	if commitment.deadline != params[:deadline]
	    		commitment.count = commitment.count + 1	#  count every change in the expiration date
	    	end

	    	commitment.deadline = params[:deadline]

	        if commitment.save
		    	currUser = User.find(commitment.user)

	        	# Notificar a todo el resto del equipo
	          	c_u = CourseUser.where(course_id: commitment.product.team.course.id)
	          	c_u.each do |cu|
		            if cu.user_id != commitment.user && cu.team_id == commitment.product.team.id || cu.rol == "CEO"
		              	##############################
		              	tokens = FcmToken.where(:user_id => cu.user_id)

		              	if tokens.length > 0 && tokens[0] != nil
			                uri = URI('https://fcm.googleapis.com/fcm/send')
			                http = Net::HTTP.new(uri.host, uri.port)
			                http.use_ssl = true
			                req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Authorization' => 'key=AAAAe3BYdgo:APA91bF13EtVd07IZdv-9XTSATSwd-d1J1n2gKjVWpppTuz7Uj1R2hnwTCL3ioL4e7F4YVhU-iMzDI66Czu9mRT3A9sqQ-HVmb24wyda-lwEukaL7eCLjJHAvnEsi8foZ2_Bsh44wtN8'})

			                req.body = {:to => tokens[0].token,
			                 :notification => {:title => 'Han editado un compromiso en uno de tus equipos', :body => 'Se ha editado un compromiso en el equipo ' + commitment.product.team.name + ' del curso ' + cu.course.name},
			                  :data => {:type => 'COMMITMENT_UPDATE', :commitment_id => commitment.id, :commitment_desc => commitment.description, :user_id => currUser.id, :user_name => currUser.names, :course_id => cu.course.id, :course_name => cu.course.name, :team_id => commitment.product.team.id, :team_name => commitment.product.team.name}}.to_json

			                response = http.request(req)
			                ##############################
	              		end
		            end
	          	end
	          	respond_to do |format|
		        	format.json {render json:  {commitment: commitment, status: :ok}.to_json}
		        end
	        else
	          respond_to do |format|
	            format.json {render json: { info: "Error updating commitment",  status: :unprocessable_entity}.to_json}
	          end
	        end
	  	end
	end

	def find_by_user
		commitments = Commitment.where( user: params[:user_id])

		# Add product logo and name
		commitments.each do |c|
			c.product_logo = c.product.logo
			c.product_name = c.product.name
		
			n = c.tasks.length
			c.execution = 0
			
			c.tasks.each do |t|
				c.execution = c.execution + t.execution
			end

			if n > 0
				c.execution = c.execution / n
			end
		end

      	respond_to do |format|
	        format.json {render json: { commitments: commitments,  status: :ok}.to_json}
      	end
	end
	
	def find_by_product
		commitments = Commitment.where( product_id: params[:product_id])

		# Add product logo and name
		commitments.each do |c|
			c.product_logo = c.product.logo
			c.product_name = c.product.name

			n = c.tasks.length
			c.execution = 0

			c.tasks.each do |t|
				c.execution = c.execution + t.execution
			end
			
			if n > 0
				c.execution = c.execution / n
			end
		end

      	respond_to do |format|
	        format.json {render json: { commitments: commitments,  status: :ok}.to_json}
      	end
	end

	def find_by_team
		commitments = Commitment.joins(:product).where(products: {team_id: params[:team_id]})

		# Add product logo and name
		commitments.each do |c|
			c.product_logo = c.product.logo
			c.product_name = c.product.name

			c.execution = 0
			n = c.tasks.length

			c.tasks.each do |t|
				c.execution = c.execution + t.execution
			end
			
			if n > 0
				c.execution = c.execution / n
			end
		end

      	respond_to do |format|
	        format.json {render json: { commitments: commitments,  status: :ok}.to_json}
      	end
	end
end
