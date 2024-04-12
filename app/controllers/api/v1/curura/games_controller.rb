# frozen_string_literal: true

module Api
  module V1
    module Curura
      class GamesController < ApplicationController
        def create
          ::Curura::Game.create!(game_params)
        end

        private

        def game_params
          params.require(:game).permit(:country, :score, :timezone, :start_time)
        end
      end
    end
  end
end
