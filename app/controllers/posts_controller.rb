class PostsController < ApplicationController

  layout "main"

  def index
    @post_new = Post.new
    @course = Course.find(params[:course_id])
    @posts = @course.posts.order('created_at DESC').paginate(:page => params[:page], :per_page => 3)
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def show
  end

  def new
  end

  def create

    @course_user = CourseUser.where(user_id: current_user.id, course_id:params[:course_id])
    course = Course.find(params[:course_id])

    if @course_user.any?

      @post = Post.new(post_params)
      @post.course_id = course.id
      @post.user = current_user
      @post.save
      puts @post.errors.count.inspect
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @course_user = CourseUser.where(user_id: current_user.id, course_id:params[:course_id])

    if @course_user.any? and @post.user==current_user
      @post.update_attributes(post_params)
      puts @post.errors.inspect
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    
    @post = Post.find(params[:id])

    if @post.user==current_user
      @post.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  private

    def post_params
        params.require(:post).permit(:post_text)
    end
end
