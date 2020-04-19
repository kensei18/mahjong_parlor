class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    current_user.like @review
    respond_to { |format| format.js }
  end

  def destroy
    @review = Like.find(params[:id]).review
    current_user.unlike @review
    respond_to { |format| format.js }
  end
end
