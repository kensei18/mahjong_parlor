class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

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

  private

  def review_params
    params.require(:review).permit(:title, :content, :overall,
                                   :cleanliness, :service, :customer)
  end
end
