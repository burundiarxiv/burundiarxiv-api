# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        @median_international_score = Game.median_international_score(solution)
        @median_national_score = Game.median_national_score(solution, country)
        @international_rank = Game.international_rank(solution, score)
        @national_rank = Game.national_rank(solution, country, score)
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
