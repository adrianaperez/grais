class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def show
     @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    #El mismo caso que con course-teams
    #yo puedo enviar el id de team desde el formulario como hidden
    @product = Product.new(product_params);
    respond_to do |format|
      if @product.save
        format.html{redirect_to products_path , notice: "Product was created successfully"}
        format.json {render json: {product: @product, status: :ok}.to_json}
        format.js
      else
        format.html { render "new", error: "The product was not created" }
        format.json {render json: {product: @product,  status: :unprocessable_entity}.to_json }
        format.js
      end
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    
    respond_to do |format|
      if @product.update_attributes(team_params)
        format.html{redirect_to team_path, notice: "Product was successfully updated"}
        format.json {render json: {product: @product, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to edit product"}
        format.json {render json: {product: @product, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.destroy
        format.html{redirect_to team_path, notice: "Product delete"}
        format.json {render json: {product: @product, status: :ok}.to_json}
        format.js
      else
        format.html { render "edit", error: "Failed to delete this product"}
        format.json {render json: {product: @product, status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  def find_products_by_course
    @course = Course.find(params[:id])

    if @course == nil
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end
    
    @products_list = Array.new
    
    if @course.teams.any?  
      @course.teams.each do |t|
        products = t.products
        puts products.inspect
        
        if products.any?
          products.each do |pd|
            @products_list << pd
          end
        end
      end
    end
    
    respond_to do |format|
      format.html{redirect_to course_path, notice: "Success"}
      format.json {render json: {products: @products_list, status: :ok}.to_json}
      format.js
    end
  end

  def find_products_by_user
    user = User.find(params[:id])

    if user == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end  

    @product_list = Array.new
    course_users = CourseUser.where(user_id: user.id)

    if course_users.any?
      course_users.each do |cu|
        products_by_course = Product.joins(:product_users).where(product_users:{course_user_id: cu.id}) 
        if products_by_course.any?
          products_by_course.each do |product|
            @product_list << product
          end  
        end
      end
    end
  
    respond_to do |format|
      format.html{redirect_to course_path, notice: "Success"}
      format.json {render json: {products: @product_list, status: :ok}.to_json}
      format.js
    end
  end

  def find_products_by_team
    team = Team.find(params[:id])

    if team == nil
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Team not found"}
        format.json {render json: {info: "Team not found", status: :not_found}.to_json}
        format.js
      end
    end

    products = team.products
    @products_list = Array.new
    if products.any?
      products.each do |pd|
        @products_list << pd
      end
    end

    respond_to do |format|
      format.html{redirect_to teams_path, notice: "Products"}
      format.json {render json: {products:@products_list, status: :ok}.to_json}
      format.js
    end
  end

  private

    def product_params
        params.require(:team).permit(:name,:description, :logo, :team_id)
    end
end
