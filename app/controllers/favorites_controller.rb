class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @parlor = Parlor.find(params[:parlor_id])
    current_user.add_to_favorites @parlor
    respond_to { |format| format.js }
  end

  def destroy
    @parlor = Favorite.find(params[:id]).parlor
    current_user.remove_from_favorites @parlor
    respond_to { |format| format.js }
  end
end
