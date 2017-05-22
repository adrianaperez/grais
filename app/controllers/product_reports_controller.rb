class ProductReportsController < ApplicationController

	def create
		@report = ProductReport.new(product_report_params);
		@report.save
		respond_to do |format|
			format.js
		end
	end

	def update
		@report = ProductReport.find(params[:id])
		@report.update_attributes(product_report_params)
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@report = ProductReport.find(params[:id])
		@report.destroy
		respond_to do |format|
			format.js
		end
	end

	def create_product_report
		report = ProductReport.new()
		report.report = params[:report]
		report.product = Product.find(params[:product_id])

		if report.product == nil
	     	respond_to do |format|
	        	format.json {render json: { info: "Product not found",  status: :not_found}.to_json}
  			end
	    else
    	  	if report.save
		    	respond_to do |format|
		      		format.json {render json:  {report: report, status: :ok}.to_json}
		    	end
    	  	else
		      	respond_to do |format|
		        	format.json {render json: { info: "Error creating report",  status: :unprocessable_entity}.to_json}
		      	end
    	  	end
    	end
    end

	def update_product_report
		report = ProductReport.find(params[:id])
		report.report = params[:report]

	  	if report == nil
		  	respond_to do |format|
		    	format.json {render json:  {info: "Report not found", status: :not_found}.to_json}
		  	end
	  	else
	    	if report.save
		      	respond_to do |format|
		        	format.json {render json:  {report: report, status: :ok}.to_json}
		      	end
	    	else
		      	respond_to do |format|
		        	format.json {render json: { info: "Error updating report",  status: :unprocessable_entity}.to_json}
		      	end
	     	end
	    end
	 end

	def find_by_team
		products = Product.where( team_id: params[:team_id])

		reports = Array.new

		products.each do |p|
			if p.product_report
				reports << p.product_report
			end
		end

	  	respond_to do |format|
	      format.json {render json: { reports: reports,  status: :ok}.to_json}
	  	end
	end

	def find_by_product
		product = Product.find(params[:product_id])

	  	respond_to do |format|
	      format.json {render json: { report: product.product_report,  status: :ok}.to_json}
  		end
	end

	private

    def product_report_params
        params.require(:product_report).permit(:report, :product_id)
    end
end
