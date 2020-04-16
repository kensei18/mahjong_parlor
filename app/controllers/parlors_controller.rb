class ParlorsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :check_admin, only: [:destroy]

  def index
    @parlors = Parlor.all
  end

  def show
    @parlor = Parlor.find(params[:id])
    @reviews = @parlor.reviews.includes(:user).order(created_at: :desc)
  end

  def new
    @parlor = Parlor.new
  end

  def create
    @parlor = Parlor.new(create_parlor_params)
    if @parlor.save
      flash[:success] = "新しい店舗を登録しました！"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    parlor = Parlor.find(params[:id])
    if parlor.update_attributes(update_parlor_params)
      flash[:success] = "#{parlor.name}の情報を更新しました！"
      redirect_to parlor_url(parlor)
    else
      flash[:danger] = "入力に不備があり、更新に失敗しました"
      redirect_to parlor_url(parlor)
    end
  end

  def destroy
    name = @parlor.name
    @parlor.destroy
    flash[:warning] = "#{name}を削除しました"
    redirect_to root_url
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
    redirect_to parlor_url(@parlor) unless current_user.admin?
  end
end
