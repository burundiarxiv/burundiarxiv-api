class HomeController < ApplicationController
  def index
    @youtubers = Youtuber.order(subscriber_count: :desc)
  end
end
