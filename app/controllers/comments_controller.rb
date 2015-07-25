class CommentsController < ApplicationController
  before_action :require_log_in, except: :show

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to @comment.post
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def new
    @comment = Comment.new(post_id: params[:post_id])
  end

  def show
    @comment = Comment.find(params[:id])
    @new_comment = Comment.new(child_params(@comment))
    @comments = @comment.post.comments_by_parent_id
  end

  private

  def comment_params
    params
      .require(:comment)
      .permit(:post_id, :content, :parent_comment_id)
      .merge(author_id: current_user.id)
  end

  def child_params(parent)
    { parent_comment_id: parent.id, post_id: parent.post_id }
  end
end
