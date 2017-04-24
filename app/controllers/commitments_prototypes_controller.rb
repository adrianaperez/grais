class CommitmentsPrototypesController < ApplicationController

	def create_commitment_prototypes
	    commitmentPrototype = CommitmentPrototype.new();
	    commitmentPrototype.description = params[:description]
	    commitmentPrototype.deadline = params[:deadline]
	    commitmentPrototype.prototype_id = params[:prototype_id]

	    respond_to do |format|
	      if commitmentPrototype.save
	        format.json {render json: {commitmentPrototype: commitmentPrototype, status: :ok}.to_json}
	      else
	      end
	    end
	end

	def update_commitment_prototypes
	    commitmentPrototype = CommitmentPrototype.find(params[:id])
	    commitmentPrototype.deadline = params[:deadline]
	    commitmentPrototype.description = params[:description]

	    respond_to do |format|
	      if commitmentPrototype.save
	        format.json {render json: {commitmentPrototype: commitmentPrototype, status: :ok}.to_json}
	      else
	        format.json {render json: {commitmentPrototype: commitmentPrototype, status: :unprocessable_entity}.to_json}
	      end
	    end
	end

	def find_by_prototype
	    prototype = Prototype.find(params[:id])

	    if prototype == nil
	      respond_to do |format|
	        format.json {render json: {info: "Prototype not found", status: :not_found}.to_json}
	      end
	    end

	    commitmentPrototypes = prototype.commitment_prototypes

	    respond_to do |format|
	      format.json {render json: {commitmentPrototypes: commitmentPrototypes, status: :ok}.to_json}
	    end
	end


end
