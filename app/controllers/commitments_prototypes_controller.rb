class CommitmentsPrototypesController < ApplicationController

  def index
    @commitment_prototypes = CommitmentPrototype.all
  end

  def show
    @commitment_prototype = CommitmentPrototype.find(params[:id])
  end

  def new
    @commitment_prototype = CommitmentPrototype.new
  end

	def create
		@commitment_prototype = CommitmentPrototype.new(commitment_prototype_params);
    respond_to do |format|
      if @commitment_prototype.save

        #Agregar el compromiso a quienes estan realizando el producto prototipo
        @products = Product.where(prototype_id: @commitment_prototype.prototype.id)
        if @products.any?
          @products.each do |p|
            @commitment = Commitment.new
            @commitment.description = @commitment_prototype.description
            @commitment.deadline = @commitment_prototype.deadline
            @commitment.commitment_prototype_id = @commitment_prototype.id
            @commitment.product_id = p.id
            @commitment.save
          end
        end

        #format.html{redirect_to commitment_prototypes_path , notice: "Commitment was created successfully"}
        format.json {render json: {product: @commitment_prototype, status: :ok}.to_json}
        format.js
      else
        #format.html { render "new", error: "The commitment was not created" }
        format.json {render json: {product: @commitment_prototype,  status: :unprocessable_entity}.to_json }
        format.js
      end
    end
	end

  def edit
    @commitment_prototype = CommitmentPrototype.find(params[:id])
  end

  def update
    @commitment_prototype = CommitmentPrototype.find(params[:id])
    
    respond_to do |format|
      if @commitment_prototype.update_attributes(commitment_params)

        #Actualizar los compromisos
        @commitment = Commitment.where(commitment_prototype_id:@commitment_prototype)

        @commitment.each do |c|
          c.description = commitment_prototype.description
          c.deadline = commitment_prototype.deadline
          c.save
        end

        format.html{redirect_to commitment_prototype_path, notice: "Product prototype was successfully updated"}
        format.json {render json: {commitment_prototype: @commitment_prototype, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to edit product"}
        format.json {render json: {commitment_prototype: @commitment_prototype, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @commitment_prototype = CommitmentPrototype.find(params[:id])
    respond_to do |format|
      if @commitment_prototype.destroy
        format.html{redirect_to commitment_prototype_path, notice: "Product delete"}
        format.json {render json: {commitment_prototype: @commitment_prototype, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to delete this product"}
        format.json {render json: {commitment_prototype: @commitment_prototype, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

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

	private

    def commitment_prototype_params
        params.require(:commitment_prototype).permit(:description, :deadline, :prototype_id)
    end
end
