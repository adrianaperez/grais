class CommitmentAbstractsController < ApplicationController

	def create_commitment_abstract
		abstract = CommitmentAbstract.new()
		abstract.abstract = params[:abstract]
		abstract.commitment = Commitment.find(params[:commitment_id])

		if abstract.commitment == nil
	     	respond_to do |format|
	        	format.json {render json: { info: "Commitment not found",  status: :not_found}.to_json}
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

	def update_commitment_abstract
		abstract = CommitmentAbstract.find(params[:id])
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

	def find_by_product
		commitments = Commitment.where( product_id: params[:product_id])

		abstracts = Array.new

		commitments.each do |c|
			if c.commitment_abstract
				abstracts << c.commitment_abstract
			end
		end

	  	respond_to do |format|
	      format.json {render json: { abstracts: abstracts,  status: :ok}.to_json}
	  	end
	end

	def find_by_commitment
		commitment = Commitment.find(params[:commitment_id])

	  	respond_to do |format|
	      format.json {render json: { abstract: commitment.commitment_abstract,  status: :ok}.to_json}
  		end
	end
end
