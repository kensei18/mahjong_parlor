class ParlorsController < ApplicationController
  def index
  end

  def new
    @parlor = Parlor.new
  end

  def create
  end
end
