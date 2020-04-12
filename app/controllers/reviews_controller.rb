class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @parlor = Parlor.find(params[:parlor_id])
    @review = Review.new
  end

  def create
  end
end
