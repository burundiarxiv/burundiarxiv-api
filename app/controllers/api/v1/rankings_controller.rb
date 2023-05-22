# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      before_action :set_median_scores, :set_rankings, :set_leaderboards

      def index; end

      private

      def set_median_scores
        @median_international_score, @median_national_score =
          MedianScoreCalculator
            .call(games: games_won_with_solution, country: country)
            .values_at(:international_score, :national_score)
      end

      def set_rankings
        @international_rank, @national_rank =
          RankingCalculator
            .call(
              games_with_solution: games_with_solution,
              games_won_with_solution: games_won_with_solution,
              country: country,
              score: score,
            )
            .values_at(:international_rank, :national_rank)
      end

      def set_leaderboards
        @best_players, @players_by_country =
          Leaderboard
            .call(
              games_with_solution: games_with_solution,
              games_won_with_solution: games_won_with_solution,
            )
            .values_at(:best_players, :players_by_country)
      end

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
