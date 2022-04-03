# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        @average_international_score =
          Game.where(solution: solution, won: true).average(:score).round(2)
      end

      private

      def solution
        params.require(:solution)
      end
    end
  end
end
