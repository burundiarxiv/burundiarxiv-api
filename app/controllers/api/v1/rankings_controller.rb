# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        @median_international_score, @median_national_score =
          MedianScoreCalculator.call(games: games_won_with_solution, country: country)

        # @international_rank = Game.international_rank(solution: solution, score: score)
        # @national_rank = Game.national_rank(solution: solution, country: country, score: score)

        # @games_with_solution = Game.with_solution(solution)
        # @games_won_with_solution = Game.won_with_solution(solution)
        @international_rank, @national_rank =
          RankingCalculator.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: country,
            score: score,
          )
        @best_players = Game.best_players(solution: solution)
        @players_by_country = Game.players_by_country(solution: solution)
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
