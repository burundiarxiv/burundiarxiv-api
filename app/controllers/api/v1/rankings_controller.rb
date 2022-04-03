# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        @average_international_score =
          Game.average_international_score(solution)
        @average_national_score = Game.average_national_score(solution, country)
      end

      private

      def solution
        params.require(:solution)
      end

      def country
        @country ||= params.require(:country)
      end
    end
  end
end
