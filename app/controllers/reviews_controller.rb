class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @parlor = Parlor.find(params[:parlor_id])
    @review = Review.new
  end

  def create
    @parlor = Parlor.find(params[:parlor_id])
    @review = current_user.reviews.build(review_params)
    @review.parlor = @parlor
    if @review.save
      flash[:success] = "新しいレビューを投稿しました！"
      redirect_to parlor_url(@parlor)
    else
      render :new
    end
  end

  def edit
    @review = current_user.reviews.find(params[:id])
  end

  def update
    @review = current_user.reviews.find(params[:id])

    if params[:delete_images]
      @review.images.purge
    end

    if @review.update_attributes(review_params)
      flash[:success] = "レビューを編集しました！"
      redirect_to parlor_url(@review.parlor)
    else
      render :edit
    end
  end

  def destroy
    review = Review.find(params[:id])
    parlor = review.parlor
    review.destroy
    flash[:warning] = "レビューを削除しました"
    redirect_to parlor_url(parlor)
  end

  private

  def review_params
    params.require(:review).permit(:title, :content, :overall,
                                   :cleanliness, :service, :customer, images: [])
  end

  def correct_user
    unless current_user.reviews.ids.include?(params[:id].to_i)
      flash[:danger] = "ほかのユーザーのレビューは編集できません"
      redirect_to root_url
    end
  end
end
