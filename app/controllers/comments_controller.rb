class CommentsController < ApplicationController
  
  def index
  end

  def show
  end

  def new
  end

  def create

    post = Post.find(params[:post_id])
    @course_user = CourseUser.where(user_id: current_user.id, course_id:post.course.id)

    if @course_user.any?
      @comment = Comment.new(comment_params)
      @comment.post_id = post.id
      @comment.user = current_user 
      @comment.save
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    @comment= Comment.find(params[:id])
    @course_user = CourseUser.where(user_id: current_user.id, course_id:@comment.post.course.id)

    if @course_user.any? and current_user == @comment.user 
      @comment.update_attributes(comment_params)
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy

    @comment= Comment.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  private

    def comment_params
        params.require(:comment).permit(:comment_text)
    end
end
