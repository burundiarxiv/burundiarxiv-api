class HomeController < ApplicationController
  def index
    @youtubers = Youtuber.order(view_count: :desc)
  end
end
