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
    list = Array.new
    if @course.teams != nil  
      @course.teams.each do |t|
        @products = t.products
        if @products != nil
         list << @products
        end
      end
    end
    if list != nil
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Success"}
        format.json {render json: {products: list, status: :ok}.to_json}
        format.js
      end

    else
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Success"}
        format.json {render json: {info: "Unprocessable entity", status: :unprocessable_entity}.to_json}
        format.js
      end
    end

  end

  def find_products_by_user
    @user = User.find(params[:id])

    if @user == nil
      respond_to do |format|
        format.html{redirect_to team_path, notice: "Course not found"}
        format.json {render json: {info: "Course not found", status: :not_found}.to_json}
        format.js
      end
    end    
    @product_list = Array.new
    c_u = CourseUser.where(user_id: @user.id)
    if c_u != nil
      c_u.each do |cu|
        @products_by_course = Product.joins(:product_users).where(product_users:{course_user_id: c_u.id}) 
        if @products_by_course != nil
          @product_list << @products_by_course 
        end
      end
    end
    if @product_list != nil
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Success"}
        format.json {render json: {products: @product_list, status: :ok}.to_json}
        format.js
      end
    else
      respond_to do |format|
        format.html{redirect_to course_path, notice: "Products not found"}
        format.json {render json: {info: "Unprocessable entity", status: :unprocessable_entity}.to_json}
        format.js
      end
    end
  end

  private

    def product_params
        params.require(:team).permit(:name,:description, :logo, :team_id)
    end
end
