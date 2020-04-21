class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:delete, :edit_content, :update_content]
  before_action :correct_user, only: [:delete, :edit_content, :update_content]

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.new_order.
      includes(:parlor, comments: :user).page(params[:page]).per(9)
  end

  def delete
  end

  def following
    @user = User.find(params[:id])
    @following = @user.following.includes(:reviews, :followers)
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.includes(:reviews, :followers)
  end

  def favorites
    @user = User.find(params[:id])
    @parlors = @user.favorite_parlors.includes(:reviews, :favorites)
  end

  def likes
    @user = User.find(params[:id])
    @reviews = @user.like_reviews.new_order
  end

  def edit_content
    respond_to { |format| format.js }
  end

  def update_content
    current_user.update_attributes(user_content_params)
    respond_to { |format| format.js }
  end

  private

  def correct_user
    redirect_to root_url unless User.find(params[:id]) == current_user
  end

  def user_content_params
    params.require(:user).permit(:content)
  end
end
