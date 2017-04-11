class CommitmentsController < ApplicationController

	def create_commitment
    	commitment = Commitment.new()
    	commitment.description = params[:description]
    	commitment.deadline = params[:deadline]
    	commitment.execution = 0
    	commitment.count = 0

    	commitment.user = User.find(params[:user_id]).id ####
    	commitment.product = Product.find(params[:product_id])

    	# validate if the user and the product were found
    	if commitment.user == nil
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
	    	#commitment.description = params[:description]
	    	
	    	if commitment.deadline != params[:deadline]
	    		commitment.count = commitment.count + 1	#  count every change in the expiration date
	    	end

	    	commitment.deadline = params[:deadline]

	        if commitment.save
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
