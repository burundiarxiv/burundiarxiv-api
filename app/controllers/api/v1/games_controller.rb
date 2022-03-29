# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
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
            :won,
            guesses: [],
          )
      end
    end
  end
end
