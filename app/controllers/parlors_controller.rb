class ParlorsController < ApplicationController
  def index
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
      flash[:danger] = "すでに登録済みの店舗です"
      render 'new'
    end
  end

  private

  def parlor_params
    params.require(:parlor).permit(:name, :address, :latitude, :longitude)
  end
end
