# frozen_string_literal: true

require_dependency "curura/ranking_calculator"
require_dependency "curura/leaderboard"

module Api
  module V1
    module Curura
      class RankingsController < ApplicationController
        def index
          set_rankings
          set_leaderboards
        end

        private

        def set_rankings
          @international_rank, @national_rank =
            ::Curura::RankingCalculator
              .call(games: games, country: country, score: score)
              .values_at(:international_rank, :national_rank)
        end

        def set_leaderboards
          @best_players, @players_by_country =
            ::Curura::Leaderboard.call(games: games).values_at(:best_players, :players_by_country)
        end

        def games
          @games ||= ::Curura::Game.today
        end

        def country
          @country ||= params.require(:country) if params[:country].present?
        end

        def score
          params.require(:score).to_i if params[:score].present?
        end
      end
    end
  end
end
