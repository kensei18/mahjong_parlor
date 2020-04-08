class UsersController < ApplicationController
  before_action :correct_user, only: [:delete]

  def index
  end

  def show

  end

  def delete
  end

  private

  def correct_user
    redirect_to root_url unless current_user.id == params[:id].to_i
  end
end
