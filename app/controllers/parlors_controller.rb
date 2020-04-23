class ParlorsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :check_admin, only: [:destroy]

  def index
    @parlors = Parlor.all
    @page_parlors = @parlors.includes(:reviews, :favorites).page(params[:page]).per(10)
  end

  def show
    @parlor = Parlor.find(params[:id])
    @reviews = @parlor.reviews.new_order.
      includes(:user, :like_users, comments: :user).page(params[:page]).per(9)
  end

  def new
    @parlor = Parlor.new
  end

  def create
    @parlor = Parlor.new(create_parlor_params)
    if @parlor.save
      flash[:success] = "#{@parlor.name}を登録しました！"
      redirect_to @parlor
    else
      render :new
    end
  end

  def update
    parlor = Parlor.find(params[:id])
    if parlor.update_attributes(update_parlor_params)
      flash[:success] = "#{parlor.name}の情報を更新しました！"
      redirect_to parlor
    else
      flash[:danger] = "入力に不備があり、更新に失敗しました"
      redirect_to parlor
    end
  end

  def destroy
    name = @parlor.name
    @parlor.destroy
    flash[:warning] = "#{name}を削除しました"
    redirect_to root_url
  end

  def search
    @keyword = params[:keyword]
    @parlors = Parlor.search(@keyword)
    @page_parlors = @parlors.includes(:reviews, :favorites).page(params[:page]).per(10)
  end

  def suggest
    render json: Parlor.search(params[:keyword], max_num: params[:max_num].to_i).pluck(:name)
  end

  private

  def create_parlor_params
    params.require(:parlor).permit(:name, :address, :latitude, :longitude)
  end

  def update_parlor_params
    params.require(:parlor).permit(:website, :smoking)
  end

  def check_admin
    @parlor = Parlor.find(params[:id])
    redirect_to @parlor unless current_user.admin?
  end
end
