class CommentsController < ApplicationController
  before_action :authenticate_user

  include Votables

  def create
    set_post(params[:post_id])
    comment = @post.comments.build(comment_params.merge(user_id: current_user.id))
    if comment.save
      redirect_to @post, notice: "notice. comment added"
    else
      flash[:error] = "error. comment not saved"
      redirect_to @post
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    if user_log_in?
      @comment.voted_by(current_user, params[:voted])
    else
      flash[:error] = "error. login needed to vote"
    end
    redirect_to post_url(@comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_post(id_param)
    @post = Post.all.select do |post|
      post.to_param == id_param
    end.first
    unless @post
      flash[:error] = "slug error"
      redirect_to root_url
    end
  end
end
