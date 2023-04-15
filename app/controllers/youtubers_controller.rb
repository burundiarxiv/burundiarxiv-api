class YoutubersController < ApplicationController
  def index
    @youtubers = Youtuber.order(view_count: :desc)
  end

  def show
    @youtuber = Youtuber.find(params[:id])
  end
end
