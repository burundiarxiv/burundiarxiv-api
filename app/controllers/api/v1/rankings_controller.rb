# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        @median_international_score = Game.median_international_score(solution: solution)
        @median_national_score = Game.median_national_score(solution: solution, country: country)
        @international_rank = Game.international_rank(solution: solution, score: score)
        @national_rank = Game.national_rank(solution: solution, country: country, score: score)
        @best_players = Game.best_players(solution: solution)
      end

      private

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
