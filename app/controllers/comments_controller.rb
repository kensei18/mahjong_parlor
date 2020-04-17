class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  def create
    @review = Review.find(params[:review_id])
    comment = current_user.comments.build(content: params[:comment][:content],
                                          review_id: @review.id)
    @comments = @review.comments.includes(:user)

    comment.save
    respond_to { |format| format.js }
  end

  def destroy
    @review = @comment.review
    @comment.destroy
    @comments = @review.comments.includes(:user)

    respond_to { |format| format.js }
  end

  private

  def correct_user
    @comment = Comment.find(params[:id])
    redirect_to parlor_path(@comment.parlor) unless current_user == @comment.user
  end
end
