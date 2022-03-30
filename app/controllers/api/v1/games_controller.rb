# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      def index
        @games =
          Game
            .where(
              start_time:
                DateTime.now.beginning_of_day..DateTime.now.end_of_day,
            )
            .order(id: :desc)
        @count = @games.count
      end

      def create
        Game.create!(game_params)
      end

      private

      def game_params
        params
          .require(:game)
          .permit(
            :country,
            :end_time,
            :solution,
            :start_time,
            :time_taken,
            :timezone,
            :won,
            guesses: [],
          )
      end
    end
  end
end
