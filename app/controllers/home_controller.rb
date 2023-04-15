class HomeController < ApplicationController
  def index
    @youtubers = Youtuber.all

    respond_to do |format|
      format.html
      # format.json { render json: @youtubers }
    end
  end
end
