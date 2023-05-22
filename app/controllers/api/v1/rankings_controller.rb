# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        rankings =
          RankingsService.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: country,
            score: score,
          )
        @median_international_score = rankings[:international_score]
        @median_national_score = rankings[:national_score]
        @international_rank = rankings[:international_rank]
        @national_rank = rankings[:national_rank]
        @best_players = rankings[:best_players]
        @players_by_country = rankings[:players_by_country]
      end

      private

      def games_won_with_solution
        @games_won_with_solution ||= Game.won_with_solution(solution)
      end

      def games_with_solution
        @games_with_solution ||= Game.with_solution(solution)
      end

      def solution
        params.require(:solution)
      end

      def country
        @country ||= params.require(:country)
      end

      def score
        params.require(:score).to_i
      end
    end
  end
end
