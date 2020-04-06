class ParlorsController < ApplicationController
  def index
    @parlors = Parlor.all
  end

  def show
    @parlor = Parlor.find(params[:id])
  end

  def new
    @parlor = Parlor.new
  end

  def create
    @parlor = Parlor.new(parlor_params)
    if @parlor.save
      flash[:success] = "新しい店舗を登録しました！"
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def parlor_params
    params.require(:parlor).permit(:name, :address, :latitude, :longitude)
  end
end
