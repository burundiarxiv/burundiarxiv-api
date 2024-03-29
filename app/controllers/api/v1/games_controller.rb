# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      def index
        @games = Game.order(id: :desc)
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
            :score,
            :solution,
            :start_time,
            :time_taken,
            :timezone,
            :won,
            :latest,
            guesses: [],
          )
      end
    end
  end
end
